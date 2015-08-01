{korubaku} = require 'korubaku'
request = require 'request'
md5 = require 'md5'

api = 'http://www.tuling123.com/openapi/api'
code_text = 100000
code_train = 305000
code_flight = 306000
code_url = 200000
code_news = 302000
code_misc = 308000

exports.default = (msg, telegram, store, server, config) ->
	korubaku (ko) =>
		q = (if !msg.text.startsWith("@#{config.name}")
			msg.text
		else
			msg.text.substring(config.name.length + 1, msg.text.length)
		).trim()

		if q.length > 30
			q = q.substring 0, 30

		console.log "tuling query: #{q}"

		# Generate the user id
		# For context
		uid = md5 msg.chat.id

		console.log "tuling uid: #{uid}"

		[err, _, body] = yield request
			url:api
			qs:
				key: config.tuling_key
				info: q
				userid: uid
		, ko.raw()

		console.log body

		if !err? and body?
			res = JSON.parse body
			a = switch res.code
				when code_text then res.text
				else '#@#$%&^%&%^&*%^'

			telegram.sendMessage msg.chat.id, a, msg.message_id
	


