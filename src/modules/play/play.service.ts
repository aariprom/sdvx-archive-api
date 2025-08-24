import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePlayDto } from './dto/create-play.dto';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime/library';

@Injectable()
export class PlayService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreatePlayDto) {
    try {
      return await this.prisma.play.create({
        data: {
          userId,
          chartId: dto.chartId,
          sourceId: dto.sourceId,
          playedAt: new Date(dto.playedAt),
          score: dto.score,
          gradeStd: dto.gradeStd ?? null,
          clearTypeStd: dto.clearTypeStd ?? null,
          gaugeValue: dto.gaugeValue != null ? dto.gaugeValue : null,
          crit: dto.crit ?? null,
          near: dto.near ?? null,
          error: dto.error ?? null,
          maxChain: dto.maxChain ?? null,
          volforce: dto.volforce != null ? dto.volforce : null,
          memo: dto.memo ?? null,
        },
      });
    } catch (e: any) {
      // @@unique([userId, chartId, sourceId, playedAt]) 충돌
      if (e instanceof PrismaClientKnownRequestError && e.code === 'P2002')
        throw new ConflictException('Duplicate play');
      throw e;
    }
  }

  async listMine(userId: string, page = 1, pageSize = 30) {
    const skip = (page - 1) * pageSize;
    const [items, total] = await this.prisma.$transaction([
      this.prisma.play.findMany({
        where: { userId },
        orderBy: { playedAt: 'desc' },
        skip,
        take: pageSize,
        include: { chart: { include: { track: true } }, source: true },
      }),
      this.prisma.play.count({ where: { userId } }),
    ]);
    return { items, total, page, pageSize };
  }
}
