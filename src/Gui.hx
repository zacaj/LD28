package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;


/**
 * ...
 * @author zacaj
 */
class Gui extends Sprite
{
	public static var gui:Gui;
		var bitmap:Bitmap;
	var inited:Bool;
	/* ENTRY POINT */
	var _deltaTime = 0.0;
	var _lastTime=0.0;
	var _speed = 1000 / 40;
	public var objectsToRemove:Array<Object_>;
	public var objects:Array<Object_>;
	public var comboText:TextField;
	public var score:TextField;
	public var addScore:TextField;
	public var gameover:TextField;
	public var flash = 0;
	public var alert = false;
	public function new() 
	{
		super();
		Gui.gui = this;
		objectsToRemove = new Array<Object_>();
		objects = new Array<Object_>();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}
	public static function addObject(b:Object_)
	{
		Gui.gui.addChild(b);
		Gui.gui.objects.push(b);
	}
	public static function removeObject(b:Object_)
	{
		if (b == null)
		return;
		
		Gui.gui.objects.remove(b);
		Gui.gui.removeChild(b);
	}
	function onEnterFrame(e) {
		var now:Float = Lib.getTimer();
		var delta = now - _lastTime;
		_deltaTime += delta - _speed;
		_lastTime = now;
		for (object in objects)
		{
			object.update(delta);
		}
		for (object in objectsToRemove)
			removeObject(object);
		objectsToRemove.splice(0, objectsToRemove.length);
		
		if(Main.combo>1)
			comboText.text = Std.string(Main.nextScore) + " x" + Std.string(Main.combo);
			else
			comboText.text = "";
		score.text = Std.string(Main.score);
		StringTools.lpad(score.text, "0", 10);
		
		if (Main.addScore > 0)
			addScore.text = "+" + Std.string(Main.addScore);
			else
			addScore.text = "";
		if (alert && !Main.gameover)
		{
			flash--;
			if(flash==0)
				bitmap.bitmapData = openfl.Assets.getBitmapData("img/border.png");
			if (flash < -30)
			{
				flash = 30;			
				bitmap.bitmapData = openfl.Assets.getBitmapData("img/alert.png");
			}
		}
		else
		{
			bitmap.bitmapData = openfl.Assets.getBitmapData("img/border.png");
		}
		if (Main.gameover)
			gameover.text = "GAME OVER";
		else
			gameover.text = "";
	}
	function makeText(x:Float, y:Float, size:Float):TextField
	{
		var myText = new TextField();
		var format:TextFormat = new TextFormat();
		format.color = 0xFFFFFF;
		format.size = 12*size;
		myText.defaultTextFormat = format;
		myText.x = x;
		myText.y = y;
		return myText;
	}
	function init() 
	{
		if (inited) return;
		inited = true;
		_lastTime = Lib.getTimer();
		y = 4 * 48;
		x = 48;
		this.addChild(bitmap = new Bitmap(openfl.Assets.getBitmapData("img/border.png")));
		bitmap.x = -x;
		bitmap.y = -y;
		
		for (o in Main.guiObjects)
			addObject(o);
		
		this.addChild(comboText = makeText(10 - x, 80-y, 1.8));
		this.addChild(score = makeText(10 - x, 10-y, 3));
		this.addChild(addScore = makeText(20 - x, 50-y, 2.1));
		this.addChild(gameover = makeText(20 - x, 300-y, 6));/*
		this.addChild(comboText = new TextField());
		comboText.x = 10-x;
		comboText.y = 80 - y;
		comboText.scaleX = comboText.scaleY = 1.8;
		comboText.textColor = 0xFFFFFF;
		
		this.addChild(score = new TextField());
		score.x = 10-x;
		score.y = 10 - y;
		score.scaleX = 3;
		score.scaleY = 3;
		score.textColor = 0xFFFFFF;
		
		this.addChild(addScore = new TextField());
		addScore.x = 20-x;
		addScore.y = 50 - y;
		addScore.scaleX = 2.1;
		addScore.scaleY = 2.1;
		addScore.textColor = 0xFFFFFF;
		
		this.addChild(gameover = new TextField());
		gameover.x = 20-x;
		gameover.y = 300 - y;
		gameover.scaleX = 6;
		gameover.scaleY = 6;
		gameover.textColor = 0xFFFFFF;*/
		
		
		//objects.push(new Filler(0));
	}
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	function added(e)
	{init() ;
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
}