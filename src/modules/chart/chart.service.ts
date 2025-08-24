import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ChartService {
  constructor(private prisma: PrismaService) {}

  // 검색: 이름/난이도/레벨
  async list(params: {
    q?: string;
    difficulty?: string;
    level?: number;
    page?: number;
    pageSize?: number;
  }) {
    const { q, difficulty, level, page = 1, pageSize = 30 } = params;
    const where: any = {};
    if (difficulty) where.difficultyLabel = difficulty as any;
    if (typeof level === 'number') where.level = level;
    if (q) {
      // 간단 like 검색
      where.track = { name: { contains: q, mode: 'insensitive' } };
    }
    const skip = (page - 1) * pageSize;
    const [items, total] = await this.prisma.$transaction([
      this.prisma.chart.findMany({
        where,
        include: { track: true },
        orderBy: [
          { track: { name: 'asc' } },
          { difficultyLabel: 'asc' },
          { level: 'asc' },
        ],
        skip,
        take: pageSize,
      }),
      this.prisma.chart.count({ where }),
    ]);
    return { items, total, page, pageSize };
  }

  // 차트별 랭킹
  async leaderboard(chartId: string, take = 50) {
    return this.prisma.play.findMany({
      where: { chartId },
      orderBy: [{ score: 'desc' }, { playedAt: 'asc' }],
      take,
      select: {
        score: true,
        gradeStd: true,
        clearTypeStd: true,
        playedAt: true,
        user: { select: { id: true, playerName: true } },
      },
    });
  }
}
