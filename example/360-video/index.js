'use strict'

import {
  PerspectiveCamera,
  OrientationInput,
  SphereGeometry,
  KeyboardInput,
  FlatMaterial,
  TouchInput,
  MouseInput,
  Texture,
  Context,
  Frame,
  Mesh,
} from 'axis3d'

import {
  OrbitCameraController
} from '../../extras/controller'

import quat from 'gl-quat'

// fullscreen canvas
const ctx = Context({regl: {attributes: {antialias: true}}})
const video = document.createElement('video')

const texture = Texture(ctx)
const material = FlatMaterial(ctx, {map: texture})

const camera = PerspectiveCamera(ctx, {position: [0, 0, 0]})
const sphere = Mesh(ctx, { geometry: SphereGeometry(ctx)})
const frame = Frame(ctx)

// inputs
const orientation = OrientationInput(ctx)
const keyboard = KeyboardInput(ctx)
const mouse = MouseInput(ctx)
const touch = TouchInput(ctx)

const inputs = { orientation, keyboard, touch, mouse }
const orbitCamera = OrbitCameraController(ctx, {
  camera, inputs,
  interpolationFactor: 0.3,
  rotation: quat.setAxisAngle([], [0, 1, 0], 0.5*Math.PI)
})

// init video
let isVideoPlaying = false
video.src = 'paramotor.mp4'
video.preload = 'metadata'
video.autoload = true
//video.load()

video.addEventListener('playing', () => { isVideoPlaying = true })
video.addEventListener('play', () => { isVideoPlaying = true })
video.addEventListener('pause', () => { isVideoPlaying = false })
video.addEventListener('error', () => { isVideoPlaying = false })
video.addEventListener('stop', () => { isVideoPlaying = false })
video.addEventListener('end', () => { isVideoPlaying = false })

video.addEventListener('timeupate', () => console.log(video.currentTime))

window.video = video
ctx.domElement.addEventListener('touchstart', onclick)
ctx.domElement.addEventListener('click', onclick)
function onclick(e) {
  e.preventDefault()
  console.log(isVideoPlaying)
  if (isVideoPlaying) { video.pause() }
  else { video.play() }
}

frame(({time}) => {
  orbitCamera(() => {
    texture({data: video})
    material(() => {
      sphere({scale: 100})
    })
  })
})
