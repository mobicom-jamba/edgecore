import AWS from "aws-sdk";
import { config } from "../config";

export class S3Service {
  private s3: AWS.S3;

  constructor() {
    AWS.config.update({
      accessKeyId: config.aws.accessKeyId,
      secretAccessKey: config.aws.secretAccessKey,
      region: config.aws.region,
    });

    this.s3 = new AWS.S3();
  }

  async uploadFile(
    buffer: Buffer,
    key: string,
    contentType: string,
    metadata?: Record<string, string>
  ): Promise<{ url: string; key: string }> {
    const params: AWS.S3.PutObjectRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
      Body: buffer,
      ContentType: contentType,
      Metadata: metadata,
      ACL: "private", // Files are private by default
    };

    try {
      const result = await this.s3.upload(params).promise();
      return {
        url: result.Location,
        key: result.Key,
      };
    } catch (error) {
      throw new Error(
        `Failed to upload file to S3: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async deleteFile(key: string): Promise<void> {
    const params: AWS.S3.DeleteObjectRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
    };

    try {
      await this.s3.deleteObject(params).promise();
    } catch (error) {
      throw new Error(
        `Failed to delete file from S3: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async getSignedUrl(key: string, expiresIn: number = 3600): Promise<string> {
    const params: AWS.S3.GetObjectRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
    };

    try {
      return this.s3.getSignedUrl("getObject", {
        ...params,
        Expires: expiresIn,
      });
    } catch (error) {
      throw new Error(
        `Failed to generate signed URL: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async getSignedUploadUrl(
    key: string,
    contentType: string,
    expiresIn: number = 3600
  ): Promise<string> {
    const params: AWS.S3.PutObjectRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
      ContentType: contentType,
    };

    try {
      return this.s3.getSignedUrl("putObject", {
        ...params,
        Expires: expiresIn,
      });
    } catch (error) {
      throw new Error(
        `Failed to generate signed upload URL: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async copyFile(sourceKey: string, destinationKey: string): Promise<void> {
    const params: AWS.S3.CopyObjectRequest = {
      Bucket: config.aws.s3Bucket,
      CopySource: `${config.aws.s3Bucket}/${sourceKey}`,
      Key: destinationKey,
    };

    try {
      await this.s3.copyObject(params).promise();
    } catch (error) {
      throw new Error(
        `Failed to copy file in S3: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async getFileMetadata(key: string): Promise<AWS.S3.HeadObjectOutput> {
    const params: AWS.S3.HeadObjectRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
    };

    try {
      return await this.s3.headObject(params).promise();
    } catch (error) {
      throw new Error(
        `Failed to get file metadata: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async listFiles(
    prefix?: string,
    maxKeys: number = 1000
  ): Promise<AWS.S3.Object[]> {
    const params: AWS.S3.ListObjectsV2Request = {
      Bucket: config.aws.s3Bucket,
      Prefix: prefix,
      MaxKeys: maxKeys,
    };

    try {
      const result = await this.s3.listObjectsV2(params).promise();
      return result.Contents || [];
    } catch (error) {
      throw new Error(
        `Failed to list files: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async makeFilePublic(key: string): Promise<void> {
    const params: AWS.S3.PutObjectAclRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
      ACL: "public-read",
    };

    try {
      await this.s3.putObjectAcl(params).promise();
    } catch (error) {
      throw new Error(
        `Failed to make file public: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }

  async makeFilePrivate(key: string): Promise<void> {
    const params: AWS.S3.PutObjectAclRequest = {
      Bucket: config.aws.s3Bucket,
      Key: key,
      ACL: "private",
    };

    try {
      await this.s3.putObjectAcl(params).promise();
    } catch (error) {
      throw new Error(
        `Failed to make file private: ${
          error instanceof Error ? error.message : "Unknown error"
        }`
      );
    }
  }
}
