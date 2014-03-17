if [ ! -n "$WERCKER_FLOWDOCK_NOTIFY_TOKEN" ]; then
  error 'Please specify the token property'
  exit 1
fi

if [ ! -n "$WERCKER_FLOWDOCK_NOTIFY_FROM_ADDRESS" ]; then
  error 'Please specify the from_address property'
  exit 1
fi

STEP_NAME=""
if [ ! -n "$WERCKER_FLOWDOCK_NOTIFY_FAILED_MESSAGE" ]; then
    if [ ! -n "$DEPLOY" ]; then
        STEP_NAME="build"
    else
        STEP_NAME="deploy"
    fi
fi

if [ ! -n "$WERCKER_FLOWDOCK_NOTIFY_PASSED_MESSAGE" ]; then
    if [ ! -n "$DEPLOY" ]; then
        STEP_NAME="build"
    else
        STEP_NAME="deploy"
    fi
fi

if [ "$WERCKER_FLOWDOCK_NOTIFY_ON" = "failed" ]; then
    if [ "$WERCKER_RESULT" = "passed" ]; then
        echo "Skipping..."
        return 0
        fi
fi

BRANCH="$WERCKER_GIT_BRANCH"
RESULT="$WERCKER_RESULT"
STARTED_BY="$WERCKER_STARTED_BY"
COMMIT_ID="$WERCKER_GIT_COMMIT"
STEP_MESSAGE="$_WERCKER_FAILED_STEP_DISPLAY_MESSAGE"

SOURCE="Wercker"
PROJECT="$APPLICATION"
LINK="https://app.wercker.com/#build/$WERCKER_BUILD_ID"
APPLICATION="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME"
SUBJECT="$APPLICATION: $STEP_NAME of $BRANCH by $STARTED_BY $RESULT $RESULT."
CONTENT="<p>Step <strong>$STEP_NAME</strong> failed.</p><p>Commit ID: $COMMIT_ID. Message:</p><pre>$STEP_MESSAGE</pre>"


FORMATTED_MESSAGE="{\"source\": \"$SOURCE\", \"from_address\": \"$WERCKER_FLOWDOCK_NOTIFY_FROM_ADDRESS\", \"subject\": \"$SUBJECT\", \"project\": \"$APPLICATION\", \"link\": \"$LINK\", \"content\": \"$CONTENT\"}"

API_URL="https://api.flowdock.com/v1/messages/team_inbox/$WERCKER_FLOWDOCK_NOTIFY_TOKEN"

COMMAND="curl -X POST -H \"Content-Type: application/json\" -d '$FORMATTED_MESSAGE' $API_URL"
echo $COMMAND
eval $COMMAND
