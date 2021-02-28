package logonBean;

public class logon
{

    // Variables
	String userID = "";
	boolean secure = false;


	public String getUserID()
	{
		return userID;
	}

	public void setUserID(String userID)
	{
		this.userID = userID;
	}

	public void setSecure()
	{
		secure = true;
	}

	public void logout()
	{
		secure = false;
	}

	public boolean getSecure()
	{
		return secure;
	}


}
