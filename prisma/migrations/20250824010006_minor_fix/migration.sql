/*
  Warnings:

  - You are about to drop the column `version` on the `Chart` table. All the data in the column will be lost.
  - You are about to alter the column `gaugeValue` on the `Play` table. The data in that column could be lost. The data in that column will be cast from `Integer` to `Decimal(3,1)`.
  - A unique constraint covering the columns `[trackId,difficultyLabel,level]` on the table `Chart` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tokenHash]` on the table `RefreshToken` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `versionAt` to the `Chart` table without a default value. This is not possible if the table is not empty.
  - Made the column `sourceId` on table `Play` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "public"."Play" DROP CONSTRAINT "Play_sourceId_fkey";

-- DropIndex
DROP INDEX "public"."Chart_trackId_difficultyLabel_key";

-- AlterTable
ALTER TABLE "public"."Chart" DROP COLUMN "version",
ADD COLUMN     "versionAt" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."Play" ALTER COLUMN "sourceId" SET NOT NULL,
ALTER COLUMN "gaugeValue" SET DATA TYPE DECIMAL(3,1);

-- CreateIndex
CREATE UNIQUE INDEX "Chart_trackId_difficultyLabel_level_key" ON "public"."Chart"("trackId", "difficultyLabel", "level");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_tokenHash_key" ON "public"."RefreshToken"("tokenHash");

-- AddForeignKey
ALTER TABLE "public"."Play" ADD CONSTRAINT "Play_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "public"."Source"("id") ON DELETE NO ACTION ON UPDATE CASCADE;
