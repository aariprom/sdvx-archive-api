import {
  IsDateString,
  IsEnum,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';
import { ClearTypeStd, GradeStd } from '@prisma/client';

export class CreatePlayDto {
  @IsString() chartId: string; // or (trackId + diff + level)로 받게 만들 수도
  @IsString() sourceId: string;
  @IsDateString() playedAt: string;

  @IsInt() score: number;
  @IsOptional() @IsEnum(GradeStd) gradeStd?: GradeStd;
  @IsOptional() @IsEnum(ClearTypeStd) clearTypeStd?: ClearTypeStd;
  @IsOptional() @IsNumber() gaugeValue?: number; // Decimal(3,1)
  @IsOptional() @IsInt() crit?: number;
  @IsOptional() @IsInt() near?: number;
  @IsOptional() @IsInt() error?: number;
  @IsOptional() @IsInt() maxChain?: number;
  @IsOptional() @IsNumber() volforce?: number; // Decimal(5,3)
  @IsOptional() @IsString() memo?: string;
}
