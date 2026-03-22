SERVICE_A_DIR=servicea
SERVICE_B_DIR=serviceb
	
.PHONY: serve-a
serve-a:
	cd $(SERVICE_A_DIR) && go run main.go

.PHONY: serve-b
serve-b:
	cd $(SERVICE_B_DIR) && go run main.go