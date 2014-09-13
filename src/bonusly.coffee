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
#   hubot give <amount> to <name|email> for <reason> <#hashtag> - gives a micro-bonus to the specified user
#   hubot bonuses - lists recent micro-bonuses
#
# Notes:
#   To use this script, you must be signed up for Bonusly (https://bonus.ly) 
#
# Author:
#   doofdoofsf

module.exports = (robot) ->
  token = process.env.HUBOT_BONUSLY_ADMIN_API_TOKEN
  adapter = robot.adapterName
  service = 'https://bonus.ly'

  unless token
    msg.reply 'The Bonusly API token is not set. Navigate to https://bonus.ly/api as an _admin_ user (important), grab the access token and set the HUBOT_BONUSLY_ADMIN_API_TOKEN environment variable.'
    return

  robot.respond /bonuses/i, (msg) ->
    msg.reply "o.k. I'm grabbing 10 recent bonuses ..."
    path="/api/v1/bonuses?access_token=#{token}&limit=10"
    msg.http(service)
      .path(path)
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            bonus_data = JSON.parse body
            bonuses = bonus_data.result
            bonuses_text = ("From #{bonus.giver.short_name} to #{bonus.receiver.short_name}: #{bonus.amount_with_currency} #{bonus.reason}" for bonus in bonuses).join('\n')
            msg.send bonuses_text
          else
            msg.reply "Request (#{service}#{path}) failed (#{res.statusCode})."


  robot.respond /(give) ?(.*)?/i, (msg) ->
    giver = msg.message.user.name.toLowerCase()
    text = msg.match[2]

    unless text?
      msg.reply "Usage: give <amount> to <name|email> for <reason> <#hashtag>"
      return
  
    msg.reply "o.k. I'll try to give that bonus ..."

    path = '/api/v1/bonuses/create_from_text'
    post = "access_token=#{token}&giver=#{giver}&client=#{adapter}&text=#{text}" 

    msg.http(service)
      .path(path)
      .header('Content-Type', 'application/x-www-form-urlencoded')
      .post(post) (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send body
          else
            msg.reply "Failed to give: (#{res.statusCode}). Tried to post (#{post}) to (#{service}#{path})"
