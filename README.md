# Auto Ebooks

Auto ebooks is a Rails app that helps you create Twitter ebooks bots. All it needs is an OAuth sign in to the bot account and the username of the account to parody.

**DO NOT USE TO SPAM, OR TO PARODY PEOPLE WHO WONT GET THE JOKE**

I'm not liable for any harm you cause by using this software.

## Installation

```sh
git clone https://github.com/penman/auto-ebooks.git
cd auto-ebooks.git
bundle install
```

You must also set the TWITTER_CONSUMER_KEY and TWITTER_CONSUMER_SECRET environment variables.

## Running

These three commands must be run **in parallel**.

```sh
rails server
rake jobs:work
rake bots:run
```

## Creating a bot

Visit http://localhost:3000 in your web browser when the app is running and follow the instructions. Bots will start running soon after being created.
