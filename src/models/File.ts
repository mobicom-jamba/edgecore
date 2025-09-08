import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { IsNotEmpty, IsEnum, IsOptional } from 'class-validator';
import { FileType } from '../types';
import { User } from './User';

@Entity('files')
export class File {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  @IsNotEmpty()
  filename!: string;

  @Column()
  @IsNotEmpty()
  originalName!: string;

  @Column()
  @IsNotEmpty()
  mimetype!: string;

  @Column()
  size!: number;

  @Column()
  @IsNotEmpty()
  url!: string;

  @Column()
  @IsNotEmpty()
  key!: string;

  @Column({
    type: 'enum',
    enum: FileType,
    default: FileType.OTHER,
  })
  @IsEnum(FileType)
  type!: FileType;

  @Column({ type: 'varchar', nullable: true })
  @IsOptional()
  description!: string;

  @Column({ default: true })
  isPublic!: boolean;

  @Column({ default: false })
  isDeleted!: boolean;

  @Column({ type: 'timestamp', nullable: true })
  deletedAt!: Date;

  @Column('jsonb', { nullable: true })
  metadata!: Record<string, any>;

  @ManyToOne(() => User, (user) => user.files, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @Column()
  userId!: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get fileExtension(): string {
    return this.originalName.split('.').pop()?.toLowerCase() || '';
  }

  get isImage(): boolean {
    return this.mimetype.startsWith('image/');
  }

  get isDocument(): boolean {
    return this.mimetype.includes('pdf') || 
           this.mimetype.includes('document') || 
           this.mimetype.includes('text');
  }

  toJSON(): Partial<File> {
    const { user, ...file } = this;
    return file;
  }
}
