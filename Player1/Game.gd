extends Node2D

var coins = 0 

func _on_Coin_coin_collect(): #check coin
	coins = coins + 1
	var CoinScore = "Coins: "+String(coins)
	Global.coins += 1
