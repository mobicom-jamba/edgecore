import nodemailer from 'nodemailer';
// import sgMail from '@sendgrid/mail'; // Commented out - package not installed
import { config } from '../config';
import { EmailTemplate, EmailType } from '../types';

export class EmailService {
  private transporter!: nodemailer.Transporter;
  private isInitialized = false;

  constructor() {
    // Don't initialize immediately - wait until first use
  }

  private initializeTransporter(): void {
    if (this.isInitialized) return;
    
    if (config.email.service === 'sendgrid') {
      // SendGrid functionality disabled - package not installed
      console.warn('SendGrid service not available - package not installed. Using SMTP fallback.');
      // Fall back to SMTP instead of throwing error
    }
    
    // For development, use a mock transporter if no SMTP credentials are provided
    if (process.env.SMTP_USER && process.env.SMTP_PASS) {
      this.transporter = nodemailer.createTransport({
        host: process.env.SMTP_HOST || 'smtp.gmail.com',
        port: parseInt(process.env.SMTP_PORT || '587', 10),
        secure: false,
        auth: {
          user: process.env.SMTP_USER,
          pass: process.env.SMTP_PASS,
        },
      });
    } else {
      // Use a mock transporter for development
      this.transporter = nodemailer.createTransport({
        streamTransport: true,
        newline: 'unix',
        buffer: true
      });
    }
    
    this.isInitialized = true;
  }

  async sendEmail(
    to: string,
    subject: string,
    html: string,
    text?: string
  ): Promise<void> {
    try {
      // Always use SMTP since SendGrid is not available
      this.initializeTransporter();
      await this.sendWithNodemailer(to, subject, html, text);
    } catch (error) {
      console.error('Email sending failed:', error);
      throw new Error(`Failed to send email: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  private async sendWithSendGrid(
    to: string,
    subject: string,
    html: string,
    text?: string
  ): Promise<void> {
    // SendGrid functionality disabled - package not installed
    throw new Error('SendGrid service not available - package not installed');
  }

  private async sendWithNodemailer(
    to: string,
    subject: string,
    html: string,
    text?: string
  ): Promise<void> {
    const mailOptions = {
      from: config.email.fromEmail,
      to,
      subject,
      text: text || this.stripHtml(html),
      html,
    };

    if (process.env.SMTP_USER && process.env.SMTP_PASS) {
      // Real SMTP sending
      await this.transporter.sendMail(mailOptions);
    } else {
      // Mock sending for development
      console.log('📧 Mock Email Sent:', {
        to,
        subject,
        from: config.email.fromEmail,
        timestamp: new Date().toISOString()
      });
      // Simulate successful sending
      await Promise.resolve();
    }
  }

  async sendWelcomeEmail(email: string, firstName: string): Promise<void> {
    const template = this.getEmailTemplate(EmailType.WELCOME, {
      firstName,
      email,
    });

    await this.sendEmail(email, template.subject, template.html, template.text);
  }

  async sendPasswordResetEmail(
    email: string,
    firstName: string,
    resetToken: string
  ): Promise<void> {
    const resetUrl = `${process.env.FRONTEND_URL || 'http://localhost:3000'}/reset-password?token=${resetToken}`;
    
    const template = this.getEmailTemplate(EmailType.PASSWORD_RESET, {
      firstName,
      resetUrl,
    });

    await this.sendEmail(email, template.subject, template.html, template.text);
  }

  async sendEmailVerification(
    email: string,
    firstName: string,
    verificationToken: string
  ): Promise<void> {
    const verificationUrl = `${process.env.FRONTEND_URL || 'http://localhost:3000'}/verify-email?token=${verificationToken}`;
    
    const template = this.getEmailTemplate(EmailType.EMAIL_VERIFICATION, {
      firstName,
      verificationUrl,
    });

    await this.sendEmail(email, template.subject, template.html, template.text);
  }

  async sendNotificationEmail(
    email: string,
    firstName: string,
    title: string,
    message: string,
    actionUrl?: string
  ): Promise<void> {
    const template = this.getEmailTemplate(EmailType.NOTIFICATION, {
      firstName,
      title,
      message,
      actionUrl,
    });

    await this.sendEmail(email, template.subject, template.html, template.text);
  }

  private getEmailTemplate(type: EmailType, data: Record<string, any>): EmailTemplate {
    const baseUrl = process.env.FRONTEND_URL || 'http://localhost:3000';
    const companyName = process.env.COMPANY_NAME || 'EdgeCore';

    switch (type) {
      case EmailType.WELCOME:
        return {
          subject: `Welcome to ${companyName}!`,
          html: `
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8">
              <title>Welcome to ${companyName}</title>
            </head>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                <h1 style="color: #2c3e50;">Welcome to ${companyName}!</h1>
                <p>Hi ${data.firstName},</p>
                <p>Thank you for joining ${companyName}! We're excited to have you on board.</p>
                <p>Your account has been successfully created. You can now start using all the features of our platform.</p>
                <div style="text-align: center; margin: 30px 0;">
                  <a href="${baseUrl}/dashboard" style="background-color: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">Get Started</a>
                </div>
                <p>If you have any questions, feel free to contact our support team.</p>
                <p>Best regards,<br>The ${companyName} Team</p>
              </div>
            </body>
            </html>
          `,
          text: `Welcome to ${companyName}!\n\nHi ${data.firstName},\n\nThank you for joining ${companyName}! We're excited to have you on board.\n\nYour account has been successfully created. You can now start using all the features of our platform.\n\nGet started: ${baseUrl}/dashboard\n\nIf you have any questions, feel free to contact our support team.\n\nBest regards,\nThe ${companyName} Team`,
        };

      case EmailType.PASSWORD_RESET:
        return {
          subject: `Reset Your ${companyName} Password`,
          html: `
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8">
              <title>Reset Your Password</title>
            </head>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                <h1 style="color: #2c3e50;">Reset Your Password</h1>
                <p>Hi ${data.firstName},</p>
                <p>We received a request to reset your password for your ${companyName} account.</p>
                <p>Click the button below to reset your password:</p>
                <div style="text-align: center; margin: 30px 0;">
                  <a href="${data.resetUrl}" style="background-color: #e74c3c; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">Reset Password</a>
                </div>
                <p>This link will expire in 1 hour for security reasons.</p>
                <p>If you didn't request this password reset, please ignore this email.</p>
                <p>Best regards,<br>The ${companyName} Team</p>
              </div>
            </body>
            </html>
          `,
          text: `Reset Your Password\n\nHi ${data.firstName},\n\nWe received a request to reset your password for your ${companyName} account.\n\nReset your password: ${data.resetUrl}\n\nThis link will expire in 1 hour for security reasons.\n\nIf you didn't request this password reset, please ignore this email.\n\nBest regards,\nThe ${companyName} Team`,
        };

      case EmailType.EMAIL_VERIFICATION:
        return {
          subject: `Verify Your ${companyName} Email`,
          html: `
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8">
              <title>Verify Your Email</title>
            </head>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                <h1 style="color: #2c3e50;">Verify Your Email Address</h1>
                <p>Hi ${data.firstName},</p>
                <p>Thank you for signing up with ${companyName}! Please verify your email address to complete your registration.</p>
                <div style="text-align: center; margin: 30px 0;">
                  <a href="${data.verificationUrl}" style="background-color: #27ae60; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">Verify Email</a>
                </div>
                <p>If you didn't create an account with us, please ignore this email.</p>
                <p>Best regards,<br>The ${companyName} Team</p>
              </div>
            </body>
            </html>
          `,
          text: `Verify Your Email Address\n\nHi ${data.firstName},\n\nThank you for signing up with ${companyName}! Please verify your email address to complete your registration.\n\nVerify your email: ${data.verificationUrl}\n\nIf you didn't create an account with us, please ignore this email.\n\nBest regards,\nThe ${companyName} Team`,
        };

      case EmailType.NOTIFICATION:
        return {
          subject: data.title,
          html: `
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8">
              <title>${data.title}</title>
            </head>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
              <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                <h1 style="color: #2c3e50;">${data.title}</h1>
                <p>Hi ${data.firstName},</p>
                <p>${data.message}</p>
                ${data.actionUrl ? `
                  <div style="text-align: center; margin: 30px 0;">
                    <a href="${data.actionUrl}" style="background-color: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px;">Take Action</a>
                  </div>
                ` : ''}
                <p>Best regards,<br>The ${companyName} Team</p>
              </div>
            </body>
            </html>
          `,
          text: `${data.title}\n\nHi ${data.firstName},\n\n${data.message}\n\n${data.actionUrl ? `Take action: ${data.actionUrl}\n\n` : ''}Best regards,\nThe ${companyName} Team`,
        };

      default:
        throw new Error(`Unknown email type: ${type}`);
    }
  }

  private stripHtml(html: string): string {
    return html.replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
  }
}
