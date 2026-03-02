local url = "https://discord.com/api/webhooks/1472113423826419788/VzZx0mt3rtnkxPpRrHUPLGeCt8pohhFE1iNcaVs9ju79rzjTUES3GSbEx5R2bQGgyj3X"

local function sendMessage(content)
    local data = {
        username = ("Computer %d"):format(os.getComputerID()),
        content = content,
        embeds = {},
        avatar_url = term.isColor() and "https://raw.githubusercontent.com/Fatboychummy-CC/SimplifyDigging/refs/heads/better/images/advanced-turtle.png"
      or "https://raw.githubusercontent.com/Fatboychummy-CC/SimplifyDigging/refs/heads/better/images/basic-turtle.png"
    }
    
    -- Send the POST request
    local response = http.post(
        url,
        textutils.serializeJSON(data),
        {["Content-Type"] = "application/json"}
    )

    if response then
        print("Message sent successfully!")
        response.close()
    else
        print("Failed to send message.")
    end
end

print("Enter message to send to Discord:")
local msg = read()
sendMessage(msg)