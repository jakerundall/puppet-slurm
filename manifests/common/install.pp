# Private class
class slurm::common::install {

  if $slurm::osfamily == 'RedHat' {
    contain slurm::common::install::rpm
  }
}
