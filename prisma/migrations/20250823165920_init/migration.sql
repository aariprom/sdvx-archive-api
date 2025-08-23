-- CreateEnum
CREATE TYPE "public"."DifficultyStd" AS ENUM ('NOV', 'ADV', 'EXH', 'MXM', 'INF', 'GRV', 'HVN', 'VVD', 'XCD', 'ULT', 'ETC');

-- CreateEnum
CREATE TYPE "public"."GradeStd" AS ENUM ('S', 'AAAP', 'AAA', 'AAP', 'AA', 'AP', 'A', 'B', 'C', 'D', 'ETC');

-- CreateEnum
CREATE TYPE "public"."ClearTypeStd" AS ENUM ('PUC', 'UC', 'MAX', 'EXC', 'EFF', 'COMP', 'CRASH', 'ETC');

-- CreateEnum
CREATE TYPE "public"."SourceType" AS ENUM ('MANUAL', 'CSV', 'API', 'ETC');

-- CreateEnum
CREATE TYPE "public"."ImportStatus" AS ENUM ('PENDING', 'DONE', 'FAILED');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "playerName" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "settings" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."RefreshToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "userAgent" TEXT,
    "ip" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Track" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "artist" TEXT,
    "effecter" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Track_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Chart" (
    "id" TEXT NOT NULL,
    "trackId" TEXT NOT NULL,
    "difficultyLabel" "public"."DifficultyStd" NOT NULL,
    "level" INTEGER NOT NULL,
    "noteCount" INTEGER,
    "bpmMin" INTEGER,
    "bpmMax" INTEGER,
    "jacketUrl" TEXT,
    "version" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Chart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Source" (
    "id" TEXT NOT NULL,
    "type" "public"."SourceType" NOT NULL,
    "label" TEXT,
    "meta" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Source_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Play" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "chartId" TEXT NOT NULL,
    "sourceId" TEXT,
    "playedAt" TIMESTAMP(3) NOT NULL,
    "score" INTEGER NOT NULL,
    "gradeStd" "public"."GradeStd",
    "clearTypeStd" "public"."ClearTypeStd",
    "gaugeValue" INTEGER,
    "crit" INTEGER,
    "near" INTEGER,
    "error" INTEGER,
    "maxChain" INTEGER,
    "volforce" DECIMAL(5,3),
    "memo" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Play_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ImportJob" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "status" "public"."ImportStatus" NOT NULL DEFAULT 'PENDING',
    "fileName" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),
    "summary" JSONB,

    CONSTRAINT "ImportJob_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE INDEX "User_createdAt_idx" ON "public"."User"("createdAt");

-- CreateIndex
CREATE INDEX "RefreshToken_userId_createdAt_idx" ON "public"."RefreshToken"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "RefreshToken_expiresAt_idx" ON "public"."RefreshToken"("expiresAt");

-- CreateIndex
CREATE INDEX "Track_name_idx" ON "public"."Track"("name");

-- CreateIndex
CREATE INDEX "Chart_trackId_level_idx" ON "public"."Chart"("trackId", "level");

-- CreateIndex
CREATE INDEX "Chart_trackId_difficultyLabel_level_idx" ON "public"."Chart"("trackId", "difficultyLabel", "level");

-- CreateIndex
CREATE UNIQUE INDEX "Chart_trackId_difficultyLabel_key" ON "public"."Chart"("trackId", "difficultyLabel");

-- CreateIndex
CREATE INDEX "Play_userId_playedAt_idx" ON "public"."Play"("userId", "playedAt");

-- CreateIndex
CREATE INDEX "Play_chartId_score_idx" ON "public"."Play"("chartId", "score");

-- CreateIndex
CREATE INDEX "Play_userId_chartId_playedAt_idx" ON "public"."Play"("userId", "chartId", "playedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Play_userId_chartId_sourceId_playedAt_key" ON "public"."Play"("userId", "chartId", "sourceId", "playedAt");

-- AddForeignKey
ALTER TABLE "public"."RefreshToken" ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Chart" ADD CONSTRAINT "Chart_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "public"."Track"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Play" ADD CONSTRAINT "Play_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Play" ADD CONSTRAINT "Play_chartId_fkey" FOREIGN KEY ("chartId") REFERENCES "public"."Chart"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Play" ADD CONSTRAINT "Play_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "public"."Source"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ImportJob" ADD CONSTRAINT "ImportJob_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
