package controller
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.ChangePasswordMe;
	
	public class ChangePasswordCompleteCmd extends SimpleCommand
	{
		public function ChangePasswordCompleteCmd()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			var changeMe:ChangePasswordMe = this.facade.retrieveMediator(ChangePasswordMe.NAME) as ChangePasswordMe;
			changeMe.tips = "密码修改成功";
		}
	}
}