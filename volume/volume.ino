const int potPin = A0;
int potVal = 0;
int firstLED = 2;
int lastLED = 7;
int previous = -1;
int minDelta = 10;

void setup() {
  Serial.begin(9600);
  pinMode(potPin,INPUT);
  for (int it=firstLED; it<=lastLED; it++) {
    pinMode(it,OUTPUT);
  }
}

void loop() {
  potVal = analogRead(potPin);
    
  if (abs(potVal - previous) > minDelta) {
    Serial.print("V:");
    Serial.println(potVal);
    previous = potVal;
  }
  int range = 1023/7;
  int edge = 10; //first LED is a bit more than 0
  for (int it=firstLED; it<=lastLED; it++) {
    if (potVal > edge) {
      digitalWrite(it,HIGH);
    }
    else {
      digitalWrite(it,LOW);
    }
    edge = range*it;
  }  
}
