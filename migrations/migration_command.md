# todo migrate
1. migrate create -ext sql -dir migrations -seq create_todos_table



migrate -path migrations -database $env:DATABASE_URL up
