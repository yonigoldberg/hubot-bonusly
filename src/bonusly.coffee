# Description:
#   Allows users to give 'micro-bonuses' on bonusly via Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BONUSLY_ADMIN_API_TOKEN
#
# Commands:
#   hubot bonusly give <amount> to <name|email> for <reason> <#hashtag> - gives a micro-bonus to the specified user
#   hubot bonusly bonuses - lists recent micro-bonuses
#   hubot bonusly leaderboard <giver|receiver> -  show leaderboard for giving or receiving
#
# Notes:
#   To use this script, you must be signed up for Bonusly (https://bonus.ly)
#
# Author:
#   doofdoofsf

module.exports = (robot) ->
  token = process.env.HUBOT_BONUSLY_ADMIN_API_TOKEN
  adapter = robot.adapterName
  client = "hubot-#{robot.adapterName}"
  service = 'https://bonus.ly'

  unless token
    if msg?
      msg.send 'The Bonusly API token is not set. Navigate to https://bonus.ly/api as an _admin_ user (important), grab the access token and set the HUBOT_BONUSLY_ADMIN_API_TOKEN environment variable.'
    else
      console.log 'The Bonusly API token is not set. Navigate to https://bonus.ly/api as an _admin_ user (important), grab the access token and set the HUBOT_BONUSLY_ADMIN environment variable.'
    return

  robot.respond /(bonusly)? bonuses/i, (msg) ->
    msg.send "o.k. I'm grabbing recent bonuses ..."
    path="/api/v1/bonuses?access_token=#{token}&limit=10"
    msg.http(service)
      .path(path)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            data = JSON.parse body
            bonuses = data.result
            bonuses_text = ("From #{bonus.giver.short_name} to #{bonus.receiver.short_name}: #{bonus.amount_with_currency} #{bonus.reason}" for bonus in bonuses).join('\n')
            msg.send bonuses_text
          when 400
            data = JSON.parse body
            msg.send data.message
          else
            msg.send "Request (#{service}#{path}) failed (#{res.statusCode})."

  robot.respond /(bonusly)? ?leaderboard ?(giver|receiver)?/i, (msg) ->
    type_str = msg.match[2]
    type = if (type_str? && type_str == 'giver') then 'giver' else 'receiver'
    path="/api/v1/leaderboards/count-#{type}?access_token=#{token}&limit=10"
    msg.send "o.k. I'll pull up the top #{type}s for you ..."
    msg.http(service)
      .path(path)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            leaders = JSON.parse body
            leaders_text = ("##{index+1} with #{leader.count} bonuses: #{leader.user.first_name} #{leader.user.last_name}" for leader, index in leaders).join('\n')
            msg.send leaders_text
          when 400
            data = JSON.parse body
            msg.send data.message
          else
            msg.send "Request (#{service}#{path}) failed (#{res.statusCode})."


  robot.respond /(bonusly)? (give) ?(.*)?/i, (msg) ->
    giver = msg.message.user.name.toLowerCase()
    text = msg.match[3]

    if text?
      msg.send "o.k. I'll try to give that bonus ..."
    else
      text = ''

    path = '/api/v1/bonuses/create_from_text'
    post = "access_token=#{token}&giver=#{giver}&client=#{client}&text=#{text}"

    msg.http(service)
      .path(path)
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(post) (err, res, body) ->
        switch res.statusCode
          when 200
            data = JSON.parse body
            msg.send data.result
          when 400
            data = JSON.parse body
            msg.send data.message
          else
            msg.send "Failed to give: (#{res.statusCode}). Tried to post (#{post}) to (#{service}#{path})"
