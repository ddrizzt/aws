#Prior step: Create lambda function.
aws lambda --region ap-southeast-1 create-function --function-name lambda_cli_apigateway --runtime python2.7 --role arn:aws:iam::903699474479:role/lambda_ec2_manage --handler cli_lambda_apigw.lambda_handler --zip-file "fileb://cli_lambda_apigw.zip"


#NI: List API Gateway
aws apigateway --region ap-southeast-1 get-rest-apis 

#Create RESTAPI first
aws apigateway --region ap-southeast-1 create-rest-api --name eason_sample02 --endpoint-configuration  types=REGIONAL

#NI: Get resource information
aws apigateway --region ap-southeast-1 get-resources --rest-api-id a7np05fnwf

#Create resource
aws apigateway --region ap-southeast-1 create-resource --rest-api-id a7np05fnwf --parent-id dgiygie04k --path-part {proxy+}

#Create authorizer
aws apigateway --region ap-southeast-1 create-authorizer --rest-api-id a7np05fnwf --name 'authorizer2lambda' --type TOKEN --authorizer-uri 'arn:aws:apigateway:ap-southeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-southeast-1:903699474479:function:lambda_cli_apigateway/invocations' --identity-source 'method.request.header.Authorization' --identity-validation-expression '.{0,}' --authorizer-result-ttl-in-seconds 0

#Add permission to the lambda for apigateway authorizer request
aws lambda add-permission --region ap-southeast-1 --function-name lambda_cli_apigateway --statement-id 5 --principal apigateway.amazonaws.com --action lambda:InvokeFunction --source-arn arn:aws:execute-api:ap-southeast-1:903699474479:a7np05fnwf/authorizers/bch9pv

#NI: Get authorizer information
aws apigateway --region ap-southeast-1 get-authorizer --rest-api-id a7np05fnwf  --authorizer-id bch9pv

#NI: Test authorizer 
aws apigateway --region ap-southeast-1 test-invoke-authorizer --rest-api-id a7np05fnwf  --authorizer-id bch9pv --headers Authorization='abcer'

#Create put method
aws apigateway --region ap-southeast-1 put-method --rest-api-id i6huzpxe45 --resource-id 75ujfk --http-method ANY --authorization-type NONE --request-parameters method.request.path.proxy=true

#Put method ingetration
aws apigateway put-integration --region ap-southeast-1 --rest-api-id i6huzpxe45 --resource-id 75ujfk --http-method ANY --type HTTP_PROXY --integration-http-method ANY --uri "http://petstore-demo-endpoint.execute-api.com/petstore/pets/{proxy}" --request-parameters integration.request.path.proxy=method.request.path.proxy

#Deploy API.
TBD



