Expression has changed after it was checked

https://stackoverflow.com/questions/34364880/expression-has-changed-after-it-was-checked?rq=1
https://blog.angularindepth.com/everything-you-need-to-know-about-the-expressionchangedafterithasbeencheckederror-error-e3fd9ce7dbb4

````
import { Component, ChangeDetectorRef } from '@angular/core'; //import ChangeDetectorRef

constructor(private cdr: ChangeDetectorRef) { }
ngAfterViewChecked(){
   //your code to update the model
   this.cdr.detectChanges();
}

````

https://webdev.dartlang.org/api/angular/angular/ChangeDetectorRef-class

https://webdev.dartlang.org/api/angular/angular/ChangeDetectionStrategy-class


with @input()
changeDetection: ChangeDetectionStrategy.OnPush
