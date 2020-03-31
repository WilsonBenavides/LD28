library ld28;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';

part 'shader.dart';

WebGL.RenderingContext gl;

class Quad {
  Shader shader;
  int posLocation;
  WebGL.UniformLocation objectTransformLocation, cameraTransformLocation, viewTransformLocation;
  WebGL.UniformLocation colorLocation;

  Quad(this.shader) {
    posLocation = gl.getAttribLocation(shader.program, "a_pos");

    objectTransformLocation = gl.getUniformLocation(shader.program, "u_objectTransform");
    cameraTransformLocation = gl.getUniformLocation(shader.program, "u_cameraTransform");
    viewTransformLocation = gl.getUniformLocation(shader.program, "u_viewTransform");
    gl.getUniformLocation(shader.program, "u_color");

    Float32List vertexArray = new Float32List(4*3);
    vertexArray.insertAll(0*3, [0.0, 0.0, 0.0]);
    vertexArray.insertAll(1*3, [1.0, 0.0, 0.0]);
    vertexArray.insertAll(2*3, [1.0, 1.0, 0.0]);
    vertexArray.insertAll(3*3, [0.0, 1.0, 0.0]);
    Int16List indexArray = new Int16List(6);
    indexArray.insertAll(0, [0, 1, 2, 0, 2, 3]);

    gl.useProgram(shader.program);
    gl.enableVertexAttribArray(posLocation);
    WebGL.Buffer vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.WebGL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferDataTyped(WebGL.WebGL.ARRAY_BUFFER, vertexArray, WebGL.WebGL.STATIC_DRAW);
    gl.vertexAttribPointer(posLocation, 3, WebGL.WebGL.FLOAT, false, 0, 0);
  }

  Float32List viewMatrixList = new Float32List(16);
  Float32List cameraMatrixList = new Float32List(16);
  void setCamera(Matrix4 viewMatrix, Matrix4 cameraMatrix) {
    viewMatrix.copyIntoArray(viewMatrixList);
    cameraMatrix.copyIntoArray(cameraMatrixList);
    gl.uniformMatrix4fv(viewTransformLocation, false, viewMatrixList);
    gl.uniformMatrix4fv(viewTransformLocation, false, cameraMatrixList);
  }

  void render(int x, int y, int w, int h, int uo, int vo) {

  }
}

class Game {
  CanvasElement canvas;

  Math.Random random;

  void start() {
    random = new Math.Random();
    canvas = querySelector("#game_canvas");
    gl = canvas.getContext("webgl");
    if (gl == null) {
      gl = canvas.getContext("experimental.webgl");
    }
    if (gl != null) {
      window.requestAnimationFrame(render);
    }
  }

  void render(num time) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(random.nextDouble(), random.nextDouble(), random.nextDouble(), 1.0);
    gl.clear(WebGL.WebGL.COLOR_BUFFER_BIT);
    window.requestAnimationFrame(render);
  }
}
void main() {
  new Game().start();
}