package commands

import (
	"github.com/spf13/cobra"
)

var (
	discovery bool
	intel bool
	fuzz bool
)

var rootCmd = &cobra.Command{
	Use: "Darthnet",
	Long: "Darthnet is a CLI tool for reconnaissance and information gathering. during engagements, it can be used to collect data about targets, identify vulnerabilities, and assist in penetration testing activities.",
	Run: func(cmd*cobra.Command, args []string) {
		if discovery{
			runDiscoveryScript(discovery)
			return
		}

		if intel{
			runIntelScript(intel)
			return	
		}

		if fuzz{
			runFuzzScript(fuzz)
			return
		}
	}
}

func init(){
	rootCmd.PersistentFlags().BoolVarP(&discovery, "discovery", "d", false, "Excute the discovery shell script")
	rootCmd.PersistentFlags().BoolVarP(&intel, "intel", "i", false, "Excute the intell shell script")
	rootCmd.PresistentFlags().BoolVarP(&fuzz, "fuzz", "f", false, "Excute the fuzzing shell script")
}