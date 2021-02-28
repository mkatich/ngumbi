/*********************************************************************
*	File: SendMail.java
*	Description: Contains method "send" that sends an email with the
*	given data.
*	Based on the example found here created by Srinivas (Oracle): 
*	http://www.oracle.com/technology/sample_code/tech/java/jsps/ojsp/sendmail.html
*
*	Created: 02/06/06
*	Author: Michael Katich
*
*	Last Modified: 02/07/06
*	By: Michael Katich
*********************************************************************/

package SendMailBean;
import javax.mail.*;          //JavaMail packages
import javax.mail.internet.*; //JavaMail Internet packages
import java.util.*;           //Java Util packages


public class SendMail {
	
	
	private static final String SMTP_HOST_NAME = "10.0.0.5";
	private static final String SMTP_AUTH_USER = "support";
	//private static final String SMTP_AUTH_PWD  = "p21uponc";
	private static final String SMTP_AUTH_PWD  = "xp3907";
	
	
	
	
	//		** getSMTP **
	// This method is used to store the SMTP server currently being used by the system
	// in one place for easier changing.  I could specify the SMTP individually for each
	// time sending email (from vc_send_eval2.jsp for example) or just use this if want to
	// use one SMTP in every place and if changing, only edit it in one place.
	//
	// returns: string holding SMTP server address to use
	//public static String getSMTP(){	return SMTP_HOST_NAME;	}
	
	
	//		** SMTPAuthenticator **
	// SimpleAuthenticator is used to do simple authentication
	// when the SMTP server requires it.
	//
	private class SMTPAuthenticator extends javax.mail.Authenticator
	{
	
        @Override
	    public PasswordAuthentication getPasswordAuthentication()
	    {
	        String username = SMTP_AUTH_USER;
	        String password = SMTP_AUTH_PWD;
	        return new PasswordAuthentication(username, password);
	    }
	}
	
	
	//		** send **
	// This method takes arguments describing an email and SMTP server and sends an email.
	// If the text/html portion is blank ("") then email clients display the text/plain portion.
	//
	// arguments: 	p_from - String, from email address
	//				p_to - String, to email address
	//				p_cc - String, cc email address
	//				p_bcc - String, bcc email address
	//				p_subject - String, subject of email
	//				p_textplain_message - String, email body, plaintext version
	//				p_texthtml_message - String, email body, html formatted version
	//				p_smtpServer - String, SMTP server address (eg. mail.essdatarecovery.com) (got rid of this in favor of 
	//									one instance variable to hold it for easy changing (SMTP_HOST_NAME)
	//
	// returns: string success or error message
	//	
	public String send(String p_from, String p_to, String p_cc, String p_bcc,
                                    String p_subject, String p_textplain_message, String p_texthtml_message) {
	                  
		
		String l_result = "";
		
		//not using this anymore, using the instance variable SMTP_HOST_NAME
		//String l_host = p_smtpServer;// Name of the Host machine where the SMTP server is running

		//Set the host smtp address
		Properties l_props = new Properties();
		l_props.put("mail.smtp.host", SMTP_HOST_NAME);
		l_props.put("mail.smtp.auth", "true");
		
		Authenticator auth = new SMTPAuthenticator();
		//Session l_session = Session.getDefaultInstance(l_props, auth);
		//I had to change getDefaultInstance to getInstance after started authenticating
		Session l_session = Session.getInstance(l_props, auth);
		
		l_session.setDebug(true); // Enable the debug mode
		
		try {
			MimeMessage l_msg = new MimeMessage(l_session); // Create a New message
			l_msg.setFrom(new InternetAddress(p_from)); // Set the From address
			
			/*
			//Set the Reply To address(es).  setReplyTo takes an array of Addresses
			InternetAddress replyTo1 = new InternetAddress("blah@blah.com");
			InternetAddress[] replyTos = new InternetAddress[1];
			replyTos[0] = replyTo1;
			l_msg.setReplyTo(replyTos); // Set the Reply To address
			*/
			
			// Setting the "To recipients" addresses
			l_msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(p_to, false));
			
			// Setting the "Cc recipients" addresses
			l_msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse(p_cc, false));
			
			// Setting the "BCc recipients" addresses
			l_msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(p_bcc, false));
			
			l_msg.setSubject(p_subject); // Sets the Subject
	      
	        // Create an "Alternative" Multipart message
			Multipart l_mp = new MimeMultipart("alternative");
			
			//Add the text/plain part to the Multipart message
			BodyPart bp1 = new MimeBodyPart();
			bp1.setContent(p_textplain_message, "text/plain");
			l_mp.addBodyPart(bp1);
			
			//Do the same with the text/html part
			//don't include it if it's blank, otherwise gmail would just show blank email
			//even if there is a plain text part
			BodyPart bp2 = new MimeBodyPart();
			if (!p_texthtml_message.equals("")){
				bp2.setContent(p_texthtml_message, "text/html");
				l_mp.addBodyPart(bp2);
			}
			
			// Set the content for the message and transmit
			l_msg.setContent(l_mp);
			l_msg.setSentDate(new Date());
			Transport.send(l_msg);
	      
	
			// If here, then message is successfully sent.
			// Display Success message
			l_result = l_result + "Mail was sent To: "+p_to;
								
			//if CCed then, add html for displaying info
			if (!p_cc.equals(""))
				l_result = l_result + ", CC: "+p_cc;
			//if BCCed then, add html for displaying info
			if (!p_bcc.equals(""))
				l_result = l_result + ", BCC: "+p_bcc;
							
			l_result = l_result + " (MX: "+SMTP_HOST_NAME+")";
		}
		catch (MessagingException mex) { // Trap the MessagingException Error
			// If here, then error in sending Mail. Display Error message.
			l_result = l_result + "ERROR: "+mex.toString()+"&nbsp;&nbsp;&nbsp;&nbsp;***Attempted to send To: "+p_to+", CC: "+p_cc+", BCC: "+p_bcc+", From: "+p_from+" (MX: "+SMTP_HOST_NAME+")";
		}
		catch (Exception e) {
			// If here, then error in sending Mail. Display Error message.
			l_result = l_result + "ERROR: "+e.toString()+"&nbsp;&nbsp;&nbsp;&nbsp;***Attempted to send To: "+p_to+", CC: "+p_cc+", BCC: "+p_bcc+", From: "+p_from+" (MX: "+SMTP_HOST_NAME+")";
			//e.printStackTrace();
		}
		finally {
			return l_result;
		}
	}
}

