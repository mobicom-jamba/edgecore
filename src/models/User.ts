import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  BeforeInsert,
  BeforeUpdate,
} from 'typeorm';
import { IsEmail, IsNotEmpty, MinLength, IsEnum } from 'class-validator';
import bcrypt from 'bcryptjs';
import { config } from '../config';
import { UserRole } from '../types';
import { File } from './File';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @Column()
  @IsNotEmpty()
  @MinLength(2)
  firstName!: string;

  @Column()
  @IsNotEmpty()
  @MinLength(2)
  lastName!: string;

  @Column()
  @IsNotEmpty()
  @MinLength(6)
  password!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER,
  })
  @IsEnum(UserRole)
  role!: UserRole;

  @Column({ default: false })
  isEmailVerified!: boolean;

  @Column({ type: 'varchar', nullable: true })
  emailVerificationToken!: string | null;

  @Column({ type: 'varchar', nullable: true })
  passwordResetToken!: string | null;

  @Column({ type: 'timestamp', nullable: true })
  passwordResetExpires!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  lastLoginAt!: Date;

  @Column({ default: true })
  isActive!: boolean;

  @Column({ type: 'varchar', nullable: true })
  avatar!: string;

  @Column({ type: 'varchar', nullable: true })
  paddleCustomerId!: string | null;

  @OneToMany(() => File, (file) => file.user)
  files!: File[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  @BeforeInsert()
  @BeforeUpdate()
  async hashPassword(): Promise<void> {
    if (this.password && !this.password.startsWith('$2a$')) {
      this.password = await bcrypt.hash(this.password, config.security.bcryptRounds);
    }
  }

  async validatePassword(password: string): Promise<boolean> {
    return bcrypt.compare(password, this.password);
  }

  get fullName(): string {
    return `${this.firstName} ${this.lastName}`;
  }

  toJSON(): Partial<User> {
    const { password, emailVerificationToken, passwordResetToken, ...user } = this;
    return user;
  }
}
