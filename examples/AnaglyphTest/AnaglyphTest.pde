/* AnaglyphTest.pde
 ** 
 ** Test for Stereo library for Processing by
 ** Angus Forbes and Charlie Roberts. Displays
 ** quads moving along z axis in stereo. Experiment
 ** with eye separation using right and left arrow
 ** keys.
 **
 ** 4/23/2010
 */

import processing.opengl.*;
import javax.media.opengl.*; 
import javax.media.opengl.GL2;
import stereo.*;

Stereo stereo = null;
Quad[] quads;
float[] Theparams = new float[3];

void setup() {

  size(640, 480, OPENGL);
  frame.setResizable(true);
  quads = new Quad[200];

  for(int i = 0; i<200; i++) {
    quads[i] = new Quad(0.004, i);
  }

  Theparams[0] = 0.85; // simetry
  Theparams[1] = 0.4; // radia distortion
  Theparams[2] = 1.0; // Y scale factor

  background(0);
  float convPlane =10.0f;
  float eyeSep = (float) (convPlane / 30f); 

  frameRate(60);

  // set last parameter according to type of stereo
  // ACTIVE, PASSIVE, ANAGLYPH_REDLEFT_CYANRIGHT, ANAGLYPH_CYANLEFT_REDRIGHT etc.
  // first constructor old version compatible
  //  stereo = new Stereo(this, eyeSep, 45f, .1f, 1000f, Stereo.StereoType.ANAGLYPH_REDLEFT_CYANRIGHT);
  // second constructor
  stereo = new Stereo(this, eyeSep, 45f, .1f, 1000f, Stereo.StereoType.ANAGLYPH_REDLEFT_CYANRIGHT, convPlane);
  // third constructor
  //stereo = new Stereo(this, 45f, .1f, 1000f, Stereo.StereoType.ANAGLYPH_REDLEFT_CYANRIGHT,convPlane);
  // fourth constructor
  //  stereo = new Stereo(this, 45f, .1f, 1000f, Stereo.StereoType.ANAGLYPH_REDLEFT_CYANRIGHT);
}

//these are test variables....
float cx = 0f; float cy = 0f; float cz = 10f;

void draw() {

  background(0,0,0,255);

  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
  GL2 gl = pgl.beginPGL().gl.getGL2(); {   
    // only needs to be called repeatedly if you are
    // changing camera position   
    stereo.start(gl, 
        cx, cy, cz,
        0f, 0f, -1f,
        0f, 1f, 0f);
    //println(cz);
    stereo.right(gl); // right eye rendering
    render(gl);

    stereo.left(gl);  // left eye rendering
    render(gl);

    // only needed for anaglyph
    stereo.end(gl);
  } pgl.endPGL();

}

void render(GL2 gl) {
  
  gl.glColor4f(1f,0f,1f,1f);

  for(int i = 0; i<200; i++) {
    quads[i].display(gl,Theparams);
  } 
}

public void keyPressed() {
  
  if (key == 'a') {
    cz += .1f;
  }

  if (key == 'z') {
    cz -= .1f;
  }

  if (key == 's') {
    Theparams[0] += .01f;
  }

  if (key == 'x') {
    Theparams[0] -= .01f;
  }

  if (key == 'd') {
    Theparams[1] += .01f;
  }

  if (key == 'c') {
    Theparams[1] -= .01f;
  }   

  if (key == 'f') {
    Theparams[2] += .01f;
  }

  if (key == 'v') {
    Theparams[2] -= .01f;
  }

  if(keyCode == LEFT) { 
    stereo.eyeSeperation -= .01;
  }
  
  if(keyCode == RIGHT) {
    stereo.eyeSeperation += .01;
  }

}
