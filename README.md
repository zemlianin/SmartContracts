### HW1 Dribnokhod
## Links:
- erc20: https://amoy.polygonscan.com/address/0xdbdf8c47c566a2656bfae5c06fbf928174c4f1bf
- erc721: https://amoy.polygonscan.com/address/0x82AeECCa746271569f06c232c980ad4096a3bD4d
- erc1155: https://amoy.polygonscan.com/address/0x33d63DF28F46dC37efbBA55AF25F734417Dd1Acb
- sbt: https://amoy.polygonscan.com/address/0xD576865FDF1A7D88168A5B6daA63A7BA51999450
## Questions 
1. Функция approve — это функция в стандартах ERC20 и ERC721, которая позволяет владельцу токенов дать 
разрешение другому адресу тратить его токены(определенное количество) от его имени. Эта функция обычно 
используется в сценариях, когда смарт-контракт или другой пользовательский адрес должены контролировать токены владельца.
2. - ERC721 — это стандарт для незаменяемых токенов (NFT). Каждый токен уникален и имеет свой особый идентификатор (tokenId).
   - ERC1155 — это стандарт для мульти-токенов, который может одновременно поддерживать как заменяемые, так и незаменяемые токены. (Может быть полезно при обработке каких либо ресурсов в играх)
3. Soulbound Token — это непередаваемый токен, который привязан к владельцу и не может быть передан другому лицу. Может быть атрибутом конкретного человека, как документ, например:
   - Дипломы или сертификаты об образовании.
   - История работы или достижения в социальной сети.
   - Голосовые права в децентрализованных автономных организациях (DAO).
4. Чтобы создать SBT, нужно переопределить, например,  ERC721 контракт таким образом, чтобы токены были непередаваемыми. Это делается путём переопределения функций transferFrom и отключения других методов передачи токенов.
## Comments
- В работе представлены реализации стандартов ERC721, ERC1155, ERC20 и SBT токенов в папке src, а также тесты для них в папке test.
- Скрипт test/AmoyTest.sol позволяет взаимодействоаать с уже развернутыми контрактами в сети Amoy.
- Скрипт src/Deploy.sh необходим для автоматического деплоя и верификации токенов.
- Скрипт test/AmoyTest.sol имеет закоментированный метод на попытку отправки SBT токенов, он работает, но если он работает, то у меня откатывается вся транзакция, и как это починить, я не придумал =( . Это строка 69, он помечен соответсвующим комментарием.
## Screens
### NFTs:
<br/>
<br/>

![image](https://github.com/user-attachments/assets/946cc263-a9c5-4d6f-adc0-afcd9f02eeef)


### Tokens "MTK"
<br/>
<br/>

![image](https://github.com/user-attachments/assets/3fa9837b-f4c9-4860-b938-9e1e93663dbe)
