# flowdock-notify

Send a message to an Flowdock room

## Options

### required

* `token` - Your Flowdock token.
* `from_address` - Email address of the sending user.

### optional

* `on` - Possible values: `always` and `failed`, default `always`

## Example


Add `FLOWDOCK_TOKEN` as deploy target or application environment variable.

```yml
build:
    after-steps:
        - flowdock-notify:
            token: $FLOWDOCK_TOKEN
            from_address: werckerbot@company.com
```
