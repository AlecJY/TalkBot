# Mini IRC Bot Client

## Build
1. Download and install MASM32 SDK
2. Add X:\masm32\bin to $PATH
3. Run
    ``` cmd
    X:\socket> bldallc.bat socket
    ```
    
## Usage
1. Add account.ini with following configurations
    ``` account.ini
    [account]
    nick = YOUR_ACCOUNT_NAME
    pass =  YOUR_TWITCH_IRC_OAUTH
    channel = CHANNEL_NAME
    ```
    
   For example:
    ``` account.ini
    [account]
    nick = TalkBot
    pass = oauth:01234567890abcdefghijklmnopqrs
    channel = #talkbot
    ```
    
2. Run socket.exe