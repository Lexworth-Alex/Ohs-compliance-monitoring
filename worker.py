import time
def run():
    while True:
        print("worker tick")
        time.sleep(30)

if __name__ == '__main__':
    run()

