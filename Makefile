NAMESPACE=nmiu-play
APP=predict

build:
	docker build -t ${NAMESPACE}/${APP} .
run:
	docker run --name=${APP} --detach=true -p 8080:8080 ${NAMESPACE}/${APP}
clean:
	docker stop ${APP} && docker rm ${APP}
reset: clean
	docker rmi ${NAMESPACE}/${APP}
interactive:
	docker run --rm --interactive --tty --name=${APP} ${NAMESPACE}/${APP} bash
push:
	docker push ${NAMESPACE}/${APP}
