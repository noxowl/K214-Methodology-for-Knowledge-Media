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
                isAvailable = true;
            } else {
                isAvailable = false;
            }
        } catch (Exception e) {
            isAvailable = false;
        }
    }
}
