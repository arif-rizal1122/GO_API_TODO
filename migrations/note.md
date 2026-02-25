# todo migrate


1. migrate create -ext sql -dir migrations -seq create_todos_table



migrate -path migrations -database $env:DATABASE_URL up


./scripts/migrate.sh up


./scripts/migrate.sh down 1


./scripts/migrate.sh create create_todos_table


