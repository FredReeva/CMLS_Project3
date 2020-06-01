// default sound
(
SynthDef.new(\saber, {
	arg amp=0.7,
	f_car=50,
	freq_mod_f=200,
	mod_mul=20,
	amp_mod_value=0.5,
	amp_mod_f=0.5,
	panPos=0,
	intensity = 1,
	//volume = 0.7,
	gate = 0;

	var car, freq_mod, amp_mod, pan, filter, env;

	env = EnvGen.ar(Env.asr(attackTime:1,sustainLevel:0.7,releaseTime:1),gate);

	freq_mod = SinOsc.ar(freq_mod_f, mul:mod_mul);
	amp_mod = SinOsc.ar(amp_mod_f) * amp_mod_value;
	amp= amp + amp_mod;
	car = SinOscFB.ar(f_car + freq_mod, amp * LinLin.kr(intensity,-1,1,0.3,2));
	pan = Pan2.ar(car, pos:panPos, level:1);
	filter = BLowPass.ar(pan, 300, amp*LinLin.kr(intensity,-1,1,1,0.5));
	Out.ar(0, filter*env);
}).add
)

//turn on sound
(
SynthDef.new(\saberFx, {
	arg amp=0.5,
	f_car=58, //ok for mod: std 58 -> range: 50-100
	freq_mod_f=200, // std 200
	mod_mul=20, // ok for mod: std 20 -> range: 20-100
	amp_mod_value=0.2, //std: 0.5 do not set over 0.7! -> range: 0.1-0.7 dangerous control
	amp_mod_f=0.5, //std: 0.5 -> range: 0.1-30
	t_on = 0,
	panPos = 0;

	var car, freq_mod, amp_mod, pan, filter, env;

	env = EnvGen.ar(Env.perc(attackTime:0.3,releaseTime:2,level:0.7),t_on);
	freq_mod = SinOsc.ar(freq_mod_f, mul:mod_mul);
	amp_mod = SinOsc.ar(amp_mod_f) * amp_mod_value;
	amp= amp + amp_mod;
	car = SinOscFB.ar(f_car + freq_mod, 3) * amp* env;
	pan = Pan2.ar(car, pos:panPos, level:1);
	filter = BLowPass.ar(pan, 15000*env,0.6 );
	Out.ar(0, filter*amp*env);
}).add
)


// osc from processing management
(
NetAddr("127.0.0.1");
b = 0;
)

(
var lightsaber, lightsaberFx;

lightsaber = Synth.new(\saber);
lightsaberFx = Synth.new(\saberFx);

OSCdef('OSCreceiver',{
	arg msg;
	var onSaber,selCol, intensity, panning, readX, readY, speed;
	onSaber = msg[1];
	selCol = msg[2];
	panning = msg[3];
	intensity = msg[4];
	speed = msg[5];

	// on / off management
	if(onSaber == 1 and: {b == 0} , { //from off to on
		// turn on lightsaber
		lightsaberFx.set(\t_on,1);
		lightsaber.set(\gate,1);
		"on".postln;
		b = 1;

	},{ if(onSaber == 0 and: {b == 1}, { // from on to off
		// turn off lightsaber
		"off".postln;
		lightsaberFx.set(\t_on,1);
		lightsaber.set(\gate,0);
		b = 0;
	},{/*do nothing?*/})});

	// set args
	// pan from -0.9 to 0.9
	lightsaber.set(\panPos,LinLin.kr(panning,-1,1,-0.9,0.9));
	// intensity from -1 to 1
	lightsaber.set(\intensity,LinLin.kr(intensity,-1,1,-1,1));
	// carrier freq from 50 to 100
	lightsaber.set(\f_car,LinLin.kr(speed,1,50,50,100));
	lightsaberFx.set(\f_car,LinLin.kr(speed,1,50,50,100));

	if(selCol == 1 , { // red
		lightsaber.set(\amp_mod_f,0.5);
		lightsaber.set(\f_filt,300);
	});

	if(selCol == 2 , { // green
		lightsaber.set(\amp_mod_f,150);
		lightsaber.set(\f_filt,300);
	});

	if(selCol == 3 , { // blue
		lightsaber.set(\amp_mod_f,350);
		lightsaber.set(\f_filt,300);
	});

	if(selCol == 4 , { // purple
		lightsaber.set(\amp_mod_f,90);
		lightsaber.set(\f_filt,800);
	});


	//msg.postln;

},"/value");

)