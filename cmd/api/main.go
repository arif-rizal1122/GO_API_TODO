package main

import (
	"Go_REST_API/internal/config"
	"Go_REST_API/internal/database"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

func main() {
 
	var cfg *config.Config
	var err error
	cfg, err = config.Load()

	if err != nil {
		log.Fatal("error : ", err)
	}

	var pool *pgxpool.Pool
	pool, err = database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatal("error : ", err)
	}
	defer pool.Close()
	
	var router *gin.Engine = gin.Default()

	router.SetTrustedProxies(nil)

	router.GET("/", func(ctx *gin.Context) {
		err := pool.Ping(ctx)
		status := "OK"
		if err != nil {
			status = "Database Connection Failed"
		}

		ctx.JSON(200, gin.H{
			"message":  "TODO API := Running",
			"status":   status,
			"database": err == nil,
		})

	})
	
	router.Run(":" + cfg.Port)

}