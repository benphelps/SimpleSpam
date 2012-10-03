-- Change this if your language uses a lot of accented letters
SSAccentScore = 0.5

SS = {}

SSBlocked = {
	
}

SS.blackList = {
	"$%d+.+%d+g",
	"%d+g.+$%d+",
	"%d+e.?u.?r.+%d+g",
	"%d+g.+%d+e.?u.?r",
	"%d+g.+e.?u.?r%d+",
	"\226\130\172%d+.+%d+g",
	"%d+g.+\226\130\172%d+",
	"\194\163%d+.+%d+g",
	"%d+g.+\194\163%d+",
}

SS.obfs = {
	"å","à","á","ä","â","ã",
	"è","é","ë","ê",
	"ì","í","ï","î",
	"ò","ó","ö","ô","õ",
	"ù","ú","ü","û",
	"¥",
	"{square}","{star}","{triangle}","{circle}",
}

SS.greyList = {
	"dollar", "pounds", "usd", "gbp",
	"www", "[,.]com", "[,.]corn", "[,.]conn", "[,.]c0m", "[,.]c0rn", "[,.]c0nn", "dotcom","cRT2m","[,.]cqm","vvwwvv",
	"anytime",
	"mins",
	"welcome",
	"cheap",
	"buy", "kauf",
	"delivery",
	"discount", "rabatt",
	"peons",
	"185", "1-85",
	"525", "1-525",
	"gold",
	"%dkgold",
	"%dgold",
	"payment",
	"bucks",
	"safe",
	"greatest",
	"sale",
	"statchanger",
	"hack",
	"20,000",
	"100,000",
	"eur",
	"code",
	"bonus",
	"stock",
	"company",
	"super",
	"price",
	-- mounts, no one has more than 1 or 2 of these so 3+ good bets is a spammer
	"Swift Shorestrider",
	"Amani Dragonhawk",
	"Savage Raptor",
	"Mottled Drake",
	"Wooly White Rhino",
	"Blazing Hippogryph",
	"Big Battle Bear",
	"Reins of the Swift Spectral Tiger",
	"Vial of the Sands",
	"X-53 Touring Rocket"
}

function SS.Check(sender)
	for _, name in pairs(SSBlocked) do
    	if name == sender then
    		return true
    	end
	end
	return false
end

function SS.SimpleSpam(self, event, msg, ...)
    
	local matchCount = 0
    local msgOrig = msg
    local sender = select(4,...)
    local line = select(10,...)
    
    msg = strlower(msg)
    
	-- blacklist
	for _, word in ipairs(SS.blackList) do
        if (string.match(msg, word)) then
        	matchCount = matchCount + 4
        end
	end
	
	-- greylist
	for _, word in ipairs(SS.greyList) do
    	if (string.match(msg, word)) then
    		matchCount = matchCount + 1
    	end
	end
	
	-- obfuscated characters
	for _, word in ipairs(SS.obfs) do
    	if (string.match(msg, word)) then
    		matchCount = matchCount + SSAccentScore
    	end
	end
	
	-- block if more than 3 points
	if (matchCount >= 3) then
		if SS.Check(sender) == false then
			SSBlocked[#SSBlocked+1] = sender
			print("|cffBA2323Blocked spam from " .. sender .. ".  Violation Score of " .. matchCount .. "|r")
		end
    	return true
	else
    	return false
	end
	
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", SS.SimpleSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", SS.SimpleSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", SS.SimpleSpam)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", SS.SimpleSpam)