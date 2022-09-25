extends Node2D

#set global state

var skill = true 
var coin_collect = false
var weapon = true
var coins = 0
var bullet_term = 0.2
var bullet_speed = 500

var minigame1 = false
var minigame2 = false
var mini_sec = 40
var mini_ms = 0
var timeover = false
var level = 1
var numberbricks=32

var boss_health = 500

export(int) var mini_health = 3
export(int) var health = 150
export(int) var max_health = 150
export(int) var skill_cool = 40

