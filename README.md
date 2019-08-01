# Heroku Architecture Designer Certification Slackbot

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Adding to Slack

1. [Create a Slack application](https://api.slack.com/)
2. Use the [Heroku Deploy button](https://heroku.com/deploy)
3. Find the “Signing Secret” in your Slack application's “App Credentials” settigs
4. Take the Heroku app URL (e.g. `https://YOUR-APP.herokuapp.com`) and add a slash command (e.g. `/study`) that points to `https://YOUR-APP.herokuapp.com/slack/actions`
5. Install the Slack app to your Workspace

## Contributing to questions

To add a question, [edit `data/quizzes/heroku-architecture.yml`](https://github.com/trineo/heroku-architecture-certification-slack-bot/blob/master/data/quizzes/heroku-architecture.yml).

Correct answers are indicated with an `*` at the end.

## Developing locally

To set up this application, run:

    bin/setup

This command will check your system for necessary dependencies, and guide you on how to install any missing. Re-run the command until you see “You're good to go!”

To run the tests:

    bin/test
