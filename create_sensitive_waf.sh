#!/bin/bash
set -e

# ====== CONFIGURATION ======
AWS_PROFILE="CENTRAL_AWS_PROFILE"
AWS_REGION="us-east-1"             # CloudFront requires us-east-1
WEB_ACL_NAME="SensitiveDataBlocker"
RULE_NAME="SensitiveDataRule"
RULE_PRIORITY=1
WEB_ACL_SCOPE="CLOUDFRONT"         # Global for CloudFront
REGEX_PATTERN_ARN="arn:aws:wafv2:us-east-1:626635400294:global/regexpatternset/SensitiveDataRegex/c5488341-fbc1-4c73-b707-b7c5fcfec684"
# ============================

export AWS_PROFILE

echo "🔍 Checking/creating Web ACL..."
EXISTING_WEB_ACL_ID=$(aws wafv2 list-web-acls \
    --scope $WEB_ACL_SCOPE \
    --region $AWS_REGION \
    --query "WebACLs[?Name=='$WEB_ACL_NAME'].Id" \
    --output text)

if [ -z "$EXISTING_WEB_ACL_ID" ] || [ "$EXISTING_WEB_ACL_ID" == "None" ]; then
    WEB_ACL_ID=$(aws wafv2 create-web-acl \
        --name "$WEB_ACL_NAME" \
        --scope $WEB_ACL_SCOPE \
        --region $AWS_REGION \
        --default-action '{"Block": {}}' \
        --visibility-config '{
            "SampledRequestsEnabled": true,
            "CloudWatchMetricsEnabled": true,
            "MetricName": "SensitiveDataBlocker"
        }' \
        --query 'Summary.Id' \
        --output text)
    echo "✅ Created new Web ACL with ID: $WEB_ACL_ID"
else
    WEB_ACL_ID=$EXISTING_WEB_ACL_ID
    echo "✅ Web ACL already exists with ID: $WEB_ACL_ID"
fi

echo "🔍 Checking if rule '$RULE_NAME' exists..."
RULE_EXISTS=$(aws wafv2 get-web-acl \
    --name "$WEB_ACL_NAME" \
    --scope $WEB_ACL_SCOPE \
    --id "$WEB_ACL_ID" \
    --region $AWS_REGION \
    --query "WebACL.Rules[?Name=='$RULE_NAME']" \
    --output text)

LOCK_TOKEN=$(aws wafv2 get-web-acl \
    --name "$WEB_ACL_NAME" \
    --scope $WEB_ACL_SCOPE \
    --id "$WEB_ACL_ID" \
    --region $AWS_REGION \
    --query 'LockToken' \
    --output text)

VISIBILITY_CONFIG=$(aws wafv2 get-web-acl \
    --name "$WEB_ACL_NAME" \
    --scope $WEB_ACL_SCOPE \
    --id "$WEB_ACL_ID" \
    --region $AWS_REGION \
    --query 'WebACL.VisibilityConfig' \
    --output json)

if [ -z "$RULE_EXISTS" ] || [ "$RULE_EXISTS" == "None" ]; then
    echo "➕ Adding rule '$RULE_NAME' to Web ACL..."

    aws wafv2 update-web-acl \
        --name "$WEB_ACL_NAME" \
        --scope $WEB_ACL_SCOPE \
        --id "$WEB_ACL_ID" \
        --region $AWS_REGION \
        --lock-token "$LOCK_TOKEN" \
        --visibility-config "$VISIBILITY_CONFIG" \
        --default-action '{"Block": {}}' \
        --rules "[
            {
                \"Name\": \"$RULE_NAME\",
                \"Priority\": $RULE_PRIORITY,
                \"Statement\": {
                    \"RegexPatternSetReferenceStatement\": {
                        \"ARN\": \"$REGEX_PATTERN_ARN\",
                        \"FieldToMatch\": {\"Body\": {}},
                        \"TextTransformations\": [{\"Priority\": 0, \"Type\": \"NONE\"}]
                    }
                },
                \"Action\": {\"Block\": {}},
                \"VisibilityConfig\": {
                    \"SampledRequestsEnabled\": true,
                    \"CloudWatchMetricsEnabled\": true,
                    \"MetricName\": \"$RULE_NAME\"
                }
            }
        ]"

    echo "✅ Rule '$RULE_NAME' added successfully."
else
    echo "✅ Rule '$RULE_NAME' already exists — no update needed."
fi

echo ""
echo "🎯 All AWS WAF resources created/updated successfully!"
echo "👉 Next step: Associate Web ACL '$WEB_ACL_NAME' with your CloudFront distribution:"
echo "   arn:aws:cloudfront::626635400294:distribution/E25HSZAEKSWEMD"
echo "   via AWS Console → CloudFront → Distributions → General → Edit → Web ACL → Associate."
