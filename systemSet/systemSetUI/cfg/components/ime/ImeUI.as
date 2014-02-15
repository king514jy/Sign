package systemSetUI.cfg.components.ime
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import systemSetUI.cfg.components.SlipHorizontalGroup;
	import systemSetUI.events.ImeEvent;
	
	public class ImeUI extends Sprite
	{
		private const ABC:String="abc";
		private const NUMBER:String="number";
		private const SYMBOL:String = "symbol";
		private var mainBtnList:Vector.<MovieClip>;
		private var shiftBtn:MovieClip;
		private var changeBtn:MovieClip;
		private var changeLanguageBtn:MovieClip;
		private var spaceBtn:MovieClip;
		private var deleteBtn:MovieClip;
		private var completeBtn:MovieClip;
		private var penSpr:Sprite;
		private var ABCList:Vector.<String>;
		private var chineseNumberList:Vector.<String>;
		private var chineseSymbolList:Vector.<String>;
		private var englishNumberList:Vector.<String>;
		private var englistSymbolList:Vector.<String>;
		private var nowList:Vector.<String>;
		private var isEnglishStatus:Boolean;
		private var isShift:Boolean;
		private var status:String;
		private var inputTxt:TextField;
		private var imeSever:ImeSever;
		private var selectedAr:Array;
		private var slipGroup:SlipHorizontalGroup;
		private var characterList:Vector.<CharacterGroup>;
		public function ImeUI()
		{
			ABCList = new Vector.<String>();
			ABCList.push("Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M");
			chineseNumberList = new Vector.<String>();
			chineseNumberList.push("1","2","3","4","5","6","7","8","9","0","-","/","：","；","（","）","￥","@",".","。","，","、","？","！","“","”");
			chineseSymbolList = new Vector.<String>();
			chineseSymbolList.push("【","】","｛","｝","#","%","-","*","+","＝","_","——","|","～","《","》","&","·","…","，","？","！","’","‘","“","”");
			englishNumberList = new Vector.<String>();
			englishNumberList.push("1","2","3","4","5","6","7","8","9","0","-","/",":",";","(",")","$","&","@",".",",","?","!","'","`","~");
			englistSymbolList = new Vector.<String>();
			englistSymbolList.push("[","]","{","}","#","%","^","*","+","=","_","|","~","<",">","€","£","¥",".",",","?","!","'","@","→","®");
			mainBtnList = new Vector.<MovieClip>();
			for(var i:int=0;i<26;i++)
			{
				var mc:MovieClip = this.getChildByName("b"+i) as MovieClip;
				mc.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				mc.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				mc.addEventListener(MouseEvent.CLICK,mouseClick);
				mainBtnList.push(mc);
			}
			status = ABC;
			setKeyboard();
			
			shiftBtn = this.getChildByName("shift_mc") as MovieClip;
			shiftBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			shiftBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			shiftBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			changeBtn = this.getChildByName("change_mc") as MovieClip;
			changeBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			changeBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			changeBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			changeLanguageBtn = this.getChildByName("change_language_mc") as MovieClip;
			changeLanguageBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			changeLanguageBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			changeLanguageBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			spaceBtn = this.getChildByName("space_mc") as MovieClip;
			spaceBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			spaceBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			spaceBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			deleteBtn = this.getChildByName("delete_mc") as MovieClip;
			deleteBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			deleteBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			deleteBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			completeBtn = this.getChildByName("complete_mc") as MovieClip;
			completeBtn.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			completeBtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			completeBtn.addEventListener(MouseEvent.CLICK,mouseClick);
			
			penSpr = this.getChildByName("pen_mc") as Sprite;
			penSpr.visible = false;
			createInputTxt();
			imeSever = new ImeSever();
			slipGroup = new SlipHorizontalGroup(1024,60);
			slipGroup.y = 50;
			this.addChild(slipGroup);
			characterList = new Vector.<CharacterGroup>();
		}
		private function setKeyboard():void
		{
			switch(status)
			{
				case ABC:
					nowList = ABCList;
					break;
				case NUMBER:
					if(isEnglishStatus)
						nowList = englishNumberList;
					else
						nowList = chineseNumberList;
					break;
				case SYMBOL:
					if(isEnglishStatus)
						nowList = englistSymbolList;
					else
						nowList = chineseSymbolList;
					break;
			}
			for(var i:int = 0;i<26;i++)
			{
				mainBtnList[i].value_txt.text = nowList[i];
			}
		}
		private function createInputTxt():void
		{
			inputTxt = new TextField();
			inputTxt.x = 4;
			inputTxt.y = 13;
			inputTxt.autoSize = TextFieldAutoSize.LEFT;
			inputTxt.multiline = false;
			inputTxt.wordWrap = false;
			var tff:TextFormat = new TextFormat(null,32,0xffffff);
			inputTxt.defaultTextFormat = tff;
			this.addChild(inputTxt);
		}
		private function mouseDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
		}
		private function mouseUp(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		private function mouseClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var id:int = mainBtnList.indexOf(mc);
			if(id!=-1)
			{
				handleInput(id);
			}
			else
			{
				switch(mc)
				{
					case shiftBtn:
						handleShift();
						break;
					case changeBtn:
						handleChange();
						break;
					case changeLanguageBtn:
						handleChangeLanguage();
						break;
					case spaceBtn:
						handleSpace();
						break;
					case deleteBtn:
						handleDelete();
						break;
					case completeBtn:
						handleComplete();
						break;
				}
			}
		}
		private function handleInput(id:int):void
		{
			if(status!=ABC)
			{
				dispatchEvent(new ImeEvent(ImeEvent.INPUT,nowList[id]));
			}
			else
			{
				if(isEnglishStatus)
				{
					if(isShift)
						dispatchEvent(new ImeEvent(ImeEvent.INPUT,ABCList[id]));
					else
						dispatchEvent(new ImeEvent(ImeEvent.INPUT,ABCList[id].toLowerCase()));
				}
				else
				{
					handleChinese(id);
				}
			}
		}
		private function handleChinese(id:int):void
		{
			inputTxt.appendText(ABCList[id].toLowerCase());
			handleInputBack();
			serchWord();
		}
		private function serchWord():void
		{
			clear();
			var str:String = inputTxt.text;
			selectedAr = imeSever.getTetterByCode(str);
			var le:uint = selectedAr.length;
			if(le>0)
			{
				for(var i:int=0;i<le;i++)
				{
					var charaterGroup:CharacterGroup = new CharacterGroup();
					charaterGroup.character = checkWord(selectedAr[i]);
					if(i==0)
						charaterGroup.x = 0;
					else
						charaterGroup.x = characterList[i-1].x+characterList[i-1].width+1;
					slipGroup.addItem(charaterGroup);
					charaterGroup.addEventListener(ImeEvent.TAP,tapChara);
					characterList.push(charaterGroup);
				}
			}
		}
		private function clear():void
		{
			selectedAr = [];
			slipGroup.clear();
			clearCharaterList();
		}
		private function tapChara(e:ImeEvent):void
		{
			dispatchEvent(new ImeEvent(ImeEvent.INPUT,e.value));
			trace(e.value);
			clearCharaterList();
		}
		private function checkWord(str:String):String
		{
			var result:String;
			var reg:RegExp = /^[a-z]/g;
			var s:String;
			var count:int = 0;
			var le:uint = str.length;
			while (count < le)
			{
				s = str.slice(count);
				if (s.search(reg) != -1)
				{
					count++;
				}
				else
				{
					break;
				}
			}
			return s;
		}
		private function clearCharaterList():void
		{
			for each(var c:CharacterGroup in characterList)
			{
				c.removeEventListener(ImeEvent.TAP,tapChara);
				c=null;
			}
			characterList.length=0;
		}
		private function handleInputBack(close:Boolean=false):void
		{
			this.graphics.clear();
			if(!close)
			{
				this.graphics.beginFill(0x191919);
				this.graphics.drawRect(0,14,inputTxt.width+10,36);
				this.graphics.endFill();
				if(!penSpr.visible)
					penSpr.visible = true;
				penSpr.x = inputTxt.width+10;
			}
			else
			{
				if(penSpr.visible)
					penSpr.visible = false;
			}
		}
		private function handleShift():void
		{
			switch(status)
			{
				case ABC:
					if(!isShift)
					{
						shiftBtn.show_mc.gotoAndStop(2);
						isShift = true;
					}
					else
					{
						shiftBtn.show_mc.gotoAndStop(1);
						isShift = false;
					}
					break;
				case NUMBER:
					shiftBtn.show_mc.gotoAndStop(4);
					status=SYMBOL;
					setKeyboard();
					handleInputBack(true);
					inputTxt.text="";
					clear();
					break;
				case SYMBOL:
					shiftBtn.show_mc.gotoAndStop(3);
					status=NUMBER;
					setKeyboard();
					break;
				
			}
		}
		private function handleChange():void
		{
			if(status==ABC)
			{
				changeBtn.show_mc.gotoAndStop(2);
				status = NUMBER;
				shiftBtn.show_mc.gotoAndStop(3);
				handleInputBack(true);
				inputTxt.text="";
				clear();
			}
			else
			{
				changeBtn.show_mc.gotoAndStop(1);
				status = ABC;
				shiftBtn.show_mc.gotoAndStop(1);
			}
			setKeyboard();
		}
		private function handleChangeLanguage():void
		{
			isEnglishStatus = !isEnglishStatus;
			if(isEnglishStatus)
				changeLanguageBtn.show_mc.gotoAndStop(2);
			else
				changeLanguageBtn.show_mc.gotoAndStop(1);
			setKeyboard();
			handleInputBack(true);
			inputTxt.text="";
			clear();
		}
		private function handleSpace():void
		{
			dispatchEvent(new ImeEvent(ImeEvent.INPUT," "));
		}
		private function handleDelete():void
		{
			if(inputTxt.text!="")
			{
				inputTxt.text = inputTxt.text.substring(0, inputTxt.text.length - 1);
				handleInputBack();
				if(inputTxt.text!="")
					serchWord();
				else
					clear();
			}
			else
			{
				dispatchEvent(new ImeEvent(ImeEvent.DELETE));
			}
		}
		private function handleComplete():void
		{
			dispatchEvent(new ImeEvent(ImeEvent.COMPLETE));
			handleInputBack(true);
			inputTxt.text="";
			clear();
		}
	}
}