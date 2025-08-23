import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'u1@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'player1' })
  @IsString()
  playerName: string;

  @ApiProperty({ example: 'password', minLength: 8 })
  @IsString()
  @MinLength(8)
  @MaxLength(20)
  password: string;
}
