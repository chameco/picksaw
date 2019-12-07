{ commit
, subs
, devnix ? builtins.fetchTarball {
  url = "https://api.github.com/repos/kquick/devnix/tarball";
}
, configs ? builtins.fetchGit {
  url = "https://gitlab-int.galois.com/binary-analysis/nix";
  ref = "master";
}
}:

with (import devnix);

let
  submodule-commits = builtins.fromJSON (builtins.readFile subs);
  submodulesrc = m: githubSrcFetch (githubsrc "GaloisInc" m (submodule-commits."${m}"));
  submodulesrc-subpath = m: p: githubSrcFetch (githubsrc "GaloisInc" m submodule-commits."${m}" // { subpath = p; });
in

import (configs + "/saw-script/configs.nix") {
  inherit devnix;
  saw-script-src = githubSrcFetch (githubsrc "GaloisInc" "saw-script" commit);

  abcBridge-src = submodulesrc "abcBridge";
  aig-src = submodulesrc "aig";
  binary-symbols-src = submodulesrc-subpath "flexdis86" "binary-symbols";
  crucible-src = submodulesrc-subpath "crucible" "crucible";
  crucible-llvm-src = submodulesrc-subpath "crucible" "crucible-llvm";
  crucible-jvm-src = submodulesrc-subpath "crucible" "crucible-jvm";
  crucible-saw-src = submodulesrc-subpath "crucible" "crucible-saw";
  crux-src = submodulesrc-subpath "crucible" "crux";
  cryptol-src = submodulesrc "cryptol";
  # cryptol-specs-src = submodulesrc "cryptol-specs";
  cryptol-verifier-src = submodulesrc "cryptol-verifier";
  galois-dwarf-src = submodulesrc "dwarf";
  elf-edit-src = submodulesrc "elf-edit";
  flexdis86-src = submodulesrc "flexdis86";
  jvm-parser-src = submodulesrc "jvm-parser";
  jvm-verifier-src = submodulesrc "jvm-verifier";
  llvm-pretty-src = submodulesrc "llvm-pretty";
  llvm-pretty-bc-parser-src = submodulesrc "llvm-pretty-bc-parser";
  macaw-base-src = submodulesrc-subpath "macaw" "base";
  macaw-symbolic-src = submodulesrc-subpath "macaw" "symbolic";
  macaw-x86-src = submodulesrc-subpath "macaw" "x86";
  macaw-x86-symbolic-src = submodulesrc-subpath "macaw" "x86_symbolic";
  parameterized-utils-src = submodulesrc "parameterized-utils";
  saw-core-src = submodulesrc "saw-core";
  saw-core-aig-src = submodulesrc "saw-core-aig";
  saw-core-sbv-src = submodulesrc "saw-core-sbv";
  saw-core-what4-src = submodulesrc "saw-core-what4";
  what4-src = submodulesrc-subpath "crucible" "what4";
  what4-abc-src = submodulesrc-subpath "crucible" "what4-abc";
}
