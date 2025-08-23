# ---- Base (공통 OS/런타임) ----
FROM node:20-bookworm-slim AS base
WORKDIR /app

# prisma 등에서 openssl 필요. ca-certificates도 같이.
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

# ---- Deps (node_modules 설치 + prisma client 생성) ----
FROM base AS deps
ENV NODE_ENV=development
# 패키지 파일만 먼저 복사해서 캐시 최대화
COPY package*.json ./
# prisma client를 생성하려면 schema가 필요
COPY prisma ./prisma
# npm 캐시 최적화 (BuildKit 사용 시)
# RUN --mount=type=cache,target=/root/.npm npm ci
RUN npm ci
RUN npx prisma generate

# ---- Dev (로컬 컨테이너 개발용) ----
# compose.local에서 target: dev로 사용
FROM deps AS dev
USER node
ENV NODE_ENV=development
# 로컬 바인드 마운트를 쓸 거면 아래 COPY는 없어도 되지만,
# fallback 실행을 위해 최소 파일은 복사해 둔다.
COPY tsconfig*.json ./
COPY nest-cli.json ./
COPY src ./src

# Nest watch 모드 (compose에서 override 가능)
CMD ["npm", "run", "dev:dev"]

# ---- Builder (프로덕션 빌드 산출물 생성) ----
FROM deps AS builder
ENV NODE_ENV=production
# 전체 소스 복사 후 빌드
COPY . .
# schema가 바뀌었을 수 있으니 한 번 더 생성
RUN npx prisma generate
RUN npm run build
# prod용으로 devDependencies 제거
RUN npm prune --omit=dev

# ---- Prod (런타임 전용, 작고 안전하게) ----
FROM base AS prod
# 비루트 사용자
RUN useradd -m -u 1001 nodeapp
WORKDIR /app

# 빌드 산출물 & 필요한 파일만 복사
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/dist ./dist

USER nodeapp
EXPOSE 3000
CMD ["node", "dist/main.js"]
