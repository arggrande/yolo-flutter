REM We only do this because flutter web isnt really set up correctly for requests that deal with servers which have CORS on
REM See https://github.com/flutter/flutter/issues/46904#issuecomment-629363145
REM YOLO
REM Another way of potentially handling this: https://stackoverflow.com/a/66879350
"C:\Program Files\Google\Chrome\Application\chrome.exe" --disable-web-security --user-data-dir="c:\temp" %*
