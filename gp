GlobalPay Payment Gateway Configuration
Select primary payment gateway from following workflow.

Settings > Practice > My Practice Settings > Device Integration
Select GlobalPay as payment gateway
Click on Save
Click on Configuration
Select Location From Locations Dropdown
Input Account Credentials
Account Credentials = ‘800000052796:80036226:skWaYsLy1nQPPinQ45XHEcjBmhBPfm1O’

Location Based Credentials Configuration
**MerchantId** = ‘otJd7os2N5iKrsaaN7jha2ikT0HS2tDH’, 
**RegKey** = ‘5YqF1WbU30WHF14L4GgUm1jIxAj7K5ZpDUywg8iowkm’  
**TokenizationKey** = ‘IKR1NB3M2GZmJYaSRAlMSK6tpghP6diS’
Configuration Setup In Web.config
File Path: CureMD/web.config

Add following key in <appsetting></appsetting>

<add key="GlobalPayBaseURL" value="https://api.pit.paygateway.com" />
Configuration Setup In OnlinePayment_GlobalPay.aspx
File Path: CureMD\CureMD.WebApp\Billing\Billing\Payments\OnlinePayment_GlobalPay.aspx

Replace existing code with this piece of code

GlobalPayments.configure({
                    'X-GP-Api-Key': document.getElementById("txtTokenizationKey").value, // Tokenization API Key
                    'X-GP-Environment': "test"
                });
