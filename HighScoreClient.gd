extends Node
signal new_high_score

# manually input at build time
const AES_KEY = '4a9e19306b71207a1a0eaacb75e7f04faf218625a4020a300dcebc4b78997638'
const RSA_KEY = '56fc544002506a88448686893704d92a02c63943ab809e6fbc4645777dcbfcec'

var aes = AESContext.new()
var crypto = Crypto.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func getHighScore():
	$TopScoreRequest.request("https://api.queenkjuul.xyz/scores/top")

func submitScore(name, score, level):
	var json = JSON.print({
		"name": name,
		"score": score,
		"level": level,
	})
	
	for i in range(16 - (json.length() % 16)):
		json += " "

	var key = hex_to_raw(AES_KEY)
	var iv = PoolByteArray(crypto.generate_random_bytes(16))
	aes.start(AESContext.MODE_CBC_ENCRYPT, key, iv)
	var data = aes.update(json.to_utf8())
	aes.finish()
	
	if (!data):
		return

	var response = JSON.print({
		"data": Marshalls.raw_to_base64(data),
		"iv": Marshalls.raw_to_base64(iv)
	})
	var headers = ["Content-Type: application/json; charset=utf-8"]
	$SubmitScoreRequest.request("https://api.queenkjuul.xyz/scores", headers, false, HTTPClient.METHOD_POST, response)

func hex_to_raw(a_in:String) -> PoolByteArray:
	var out:PoolByteArray = PoolByteArray()
	var hs:String = '0x00'
	for i in range(0, a_in.length(), 2):
		hs[2] = a_in[i]
		hs[3] = a_in[i+1]
		out.append(hs.hex_to_int() & 0xff)
	return out

func _on_TopScoreRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	emit_signal("new_high_score", json.result.score)
