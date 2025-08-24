import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StatService {
  constructor(private prisma: PrismaService) {}

  // mode: 'perplay' | 'cumulative'
  async vfTimeline(userId: string, mode: 'perplay' | 'cumulative' = 'perplay') {
    const plays = await this.prisma.play.findMany({
      where: { userId, volforce: { not: null } },
      orderBy: { playedAt: 'asc' },
      select: { playedAt: true, volforce: true },
    });
    if (mode === 'perplay') {
      return plays.map((p) => ({ t: p.playedAt, vf: Number(p.volforce) }));
    }
    let sum = 0;
    return plays.map((p) => ({
      t: p.playedAt,
      vf: (sum += Number(p.volforce)),
    }));
  }
}
