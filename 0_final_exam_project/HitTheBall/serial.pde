import processing.serial.*;

class HTB_Serial extends PApplet {
    Serial port;
    String portName;
    int baudRate;
    boolean isAvailable = false;

    HTB_Serial(String portName, int baudRate) {
        this.portName = portName;
        this.baudRate = baudRate;

        try {
            port = new Serial(this, this.portName, this.baudRate);
            if (port.available() > 0) {
                println("Serial port is available: " + this.portName);
                isAvailable = true;
            } else {
                onSerialNotAvailable();
                isAvailable = false;
            }
        } catch (Exception e) {
            onSerialNotAvailable();
            isAvailable = false;
        }
    }

    void onSerialNotAvailable() {
        println("Serial port is not available: " + this.portName);
        println("Please check the connection and restart the program.");
        println("Available ports:" + Arrays.toString(Serial.list()));
    }

    int read() {
        if (isAvailable) {
            return port.read();
        } else {
            return -1;
        }
    }
}
