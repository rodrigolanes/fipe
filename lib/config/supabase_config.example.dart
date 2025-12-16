/// Configurações do Supabase
///
/// Este é um arquivo de exemplo. Para usar:
/// 1. Copie este arquivo como 'supabase_config.dart'
/// 2. Substitua 'YOUR_SUPABASE_URL_HERE' pela URL do seu projeto
/// 3. Substitua 'YOUR_SUPABASE_ANON_KEY_HERE' pela sua chave anônima
///
/// IMPORTANTE: O arquivo supabase_config.dart está no .gitignore e não será versionado.
class SupabaseConfig {
  /// URL do projeto Supabase
  /// Exemplo: 'https://xxxxxxxxxxx.supabase.co'
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';

  /// Chave anônima (pública) do Supabase
  /// Esta chave é segura para ser exposta no client-side pois é protegida por RLS
  /// Encontre em: Supabase Dashboard > Settings > API > anon/public key
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
}
