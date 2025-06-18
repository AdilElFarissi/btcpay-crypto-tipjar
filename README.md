# BTCPay Crypto Tip-Jar

## Version Notes:
BTCPay Crypto Tip-Jar v0.2.

This version was add: 
- A nice RGB color effect to the floating text and the object that you can turn On/Off  with a simple menu.
- Store in memory the list of your donors and the donated amounts in fiat and crypto since the Tip-Jar rez and display it to the owner in the chat if needed.

## About BTCPay Server:
- What is BTCPay Server?

BTCPay Server is a free, open-source & self-hosted cryptocurrencies payment gateway and automated invoicing software that allows self-sovereign individuals and businesses to accept cryptocurrencies payments online or in person without any fees or third-parties. You can install it aside your Opensim or in a VPS and use it in private or shared modes...

At checkout, a customer is presented with an invoice that she/he pay from her/his wallet directly to your own wallet. BTCPay Server follows the status of the invoice through the blockchain and informs you when the payment has been settled so that you can fulfill the order... In our case, the script informs you about the donation payment progress and just say thank you to the donor.

I strongly recommend you to read the BTCPay documentation before the usage of this Tip-Jar here:

https://docs.btcpayserver.org/Guide/

If you can't or don't want to install BTCPay, you can use a public instance provided by third-party hosts but read this first:

https://docs.btcpayserver.org/Deployment/ThirdPartyHosting/

You can find some third-party hosts here:

https://directory.btcpayserver.org/filter/hosts

- Training and Practice.

BTCPay team offers a demo platform linked to the Bitcoin (Test-net) where you can try and use for training with fake BTCs (free coins). Is what i used to develop this tipjar... So, create an account and follow the docu to setup your store to get your storeID. You can also setup a Hot Wallet (bad practice in production) to receive BTC test coins...

https://testnet.demo.btcpayserver.org/register

## Setting The Tip-Jar:

Open the script and modify the needed parameters...

- Set your BTCPay Server URL where you have installed it or your host URL... By default i set it to the BTCPay test-net for the demo.

- Set the IP of the BTCPay URL/server. This is used to filter the incoming HTTP for security. If you don't know it, use this:

https://www.nslookup.io/website-to-ip-lookup/

- Set your store ID: You can get your store ID from your BTCPay account. Click "Settings" in the left menu... the store ID is the first thing in the page. In the same page scroll down and **activate "Allow anyone to create invoice"**... scroll down and click save. Copy/Paste the store ID from BTCPay to the script.

- Set the crypto that you want to receive as payment. you can set here one of all the cryptos supported by BTCPay and you have set in your BTCPay wallets section. eg: BTC, DOGE, LTC, XMR... By default, BTCPay use Kraken as data source, you can see the available pairs here :

https://docs.btcpayserver.org/FAQ/Altcoin/##which-coins-does-btcpay-server-support

- Optional: Set the other parameters if needed.

## Usage:
1- The user click the Tip-Jar and select a fiat currency (Is possible to add more than the default)...

2- She/he select predefined amount or select [Custom] to set a custom amount...

3- She/he check if she/he have enough coins in her/his wallet and select [Yes] if its the case...

4- She/he open the invoice page and proceeds to the payment of the donation...

5- You are informed in real time about the progress and receive the coins directly to your wallet.

6- Share with uncle Web... (just a joke XD).

Enjoy :)

## The BTCPay Crypto Tip-Jar License:
The BTCPay Crypto Tip-Jar is open source and provided for FREE & FULL PERM under The MIT license, is a license that lets you to remix, tweak, and build upon this work, as long as you credit the original author and share your changes (if you want!) under the same license... In less words... Keep it free and make it (if you can) better for the others...

## About The Author:
Adil El Farissi, known as Web Rain in SL and OSGrid, I am an eternal amateur in action, hobbyist programmer, virtual worlds builder and crypto enthusiast... 
Between my modest contributions to the OpenSim saga there is the LinkInventory functions allowing the linked prims contents manipulation and the some security functions like the AES encryptor/decryptor... Feel free to visit my Github for more open source stuff:

https://github.com/AdilElFarissi

## My Tip-Jars:
Usually nobody cares about the developers and the creators of the free and open source contents... but if you think that my work deserves more than a simple thank you, consider making a small donation using paypal or others here:

BTC: bc1ququ5vxy3yfpqn6dd5p4xfnk35ljfgem2jf2tf2

LTC: LL6dMuxLCWy6rB7h3AHCR5nkvdV6SoFNEk

ETH: 0xa3E82b8D653Db863dBB557C8Ed8A01f6570bd990

USDT ETH Network: 0xa3E82b8D653Db863dBB557C8Ed8A01f6570bd990

USDT SOL Network: 4NzQh2wW8yxsmQzs5mVdQaaRkcpvvuonj439sQ67DgDv

DOGE: DFPrdKUtYJS8jqPpmECypdQPumCykK5jHp

XMR: 4AEJf5HiQkiiafQRzV2gmfJjUHEKUSgetjb7bqn7fQQ7GfJe21nmE29GMBhV1z6pvC45yVKVkvAH97cp4bkPpJHH4m3gZfQ

Thank You Very Much :)
