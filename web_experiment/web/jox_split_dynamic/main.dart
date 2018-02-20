import 'dart:html';

void main(){
  initComparisons();
}

void initComparisons() {
  //find all elements with an "overlay" class:
  List<Element> overlayElements = document.getElementsByClassName("img-comp-overlay");
  for (int i = 0; i < overlayElements.length; i++) {
    //pass the "overlay" element as a parameter when executing the compareImages function:
    compareImages(overlayElements[i]);
  }
}

DivElement slider;
int w, h;
Element overlayElement;
bool clicked = false;

void compareImages(Element element) {
  overlayElement = element;

  //get the width and height of the img element
  w = overlayElement.offsetWidth;
  h = overlayElement.offsetHeight;

  //set the width of the img element to 50%:
  overlayElement.style.width = "${(w / 2)}px";

  //create slider:
  slider = document.createElement("div");
  slider.setAttribute("class", "img-comp-slider");

  //insert slider
  overlayElement.parent.insertBefore(slider, overlayElement);
  //position the slider in the middle:
  slider.style.top = "${(h / 2) - (slider.offsetHeight / 2)}px";
  slider.style.left = "${(w / 2) - (slider.offsetWidth / 2)}px";
  //execute a void when the mouse button is pressed:
  slider.addEventListener("mousedown", slideReady);
  //and another void when the mouse button is released:
  window.addEventListener("mouseup", slideFinish);
  //or touched (for touch screens:
  slider.addEventListener("touchstart", slideReady);
  //and released (for touch screens:
  window.addEventListener("touchstop", slideFinish);
}

void slideReady(Event e) {
  //prevent any other actions that may occur when moving over the image:
  e.preventDefault();
  //the slider is now clicked and ready to move:
  clicked = true;
  //execute a void when the slider is moved:
  window.addEventListener("mousemove", slideMove);
  window.addEventListener("touchmove", slideMove);
}
void slideFinish(Event e) {
  //the slider is no longer clicked:
  clicked = false;
}
bool slideMove(Event e) {
  int pos;
  //if the slider is no longer clicked, exit this function:
  if (clicked == false) return false;
  //get the cursor's x position:
  pos = getCursorPos(e);
  //prevent the slider from being positioned outside the image:
  if (pos < 0) pos = 0;
  if (pos > w) pos = w;
  //execute a void that will resize the overlay image according to the cursor:
  slide(pos);
  return true;
}
int getCursorPos(MouseEvent e) {
  Rectangle<double> a;
  int x = 0;
  e = e ;//?? window.event;
  //get the x positions of the image:
  a = overlayElement.getBoundingClientRect();
  //calculate the cursor's x coordinate, relative to the image:
  x = e.client.x - a.left.toInt();
  //consider any page scrolling:
  x = x - window.pageXOffset;
  return x;
}
void slide(int x) {
  //resize the image:
  overlayElement.style.width = '${x}px';
  //position the slider:
  slider.style.left = "${overlayElement.offsetWidth - (slider.offsetWidth / 2)}px";
}